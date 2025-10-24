#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   TENSORA L2 - BSC to Tensora Bridge Tool     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Bridge contract address
BRIDGE_ADDR="0x0eAAF963708d34eB3b1459029782E820C596e438"
BSC_RPC="https://bsc-dataseed.binance.org/"
TENSORA_RPC="https://rpc2.tensora.sh"

# Prompt for private key (hidden)
echo -e "${YELLOW}Enter your private key (with or without 0x):${NC}"
read -s PRIVATE_KEY
echo ""

# Auto-add 0x prefix if missing
if [[ ! "$PRIVATE_KEY" =~ ^0x ]]; then
    PRIVATE_KEY="0x${PRIVATE_KEY}"
fi

# Derive wallet address from private key
WALLET_ADDR=$(cast wallet address --private-key "$PRIVATE_KEY" 2>/dev/null)
if [ -z "$WALLET_ADDR" ]; then
    echo -e "${RED}❌ Invalid private key!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Wallet: $WALLET_ADDR${NC}"
echo ""

# Show current balances
echo -e "${BLUE}📊 Current Balances:${NC}"
BSC_BALANCE=$(cast balance $WALLET_ADDR --rpc-url $BSC_RPC --ether 2>/dev/null)
L2_BALANCE=$(cast balance $WALLET_ADDR --rpc-url $TENSORA_RPC --ether 2>/dev/null)
echo -e "  BSC (L1):     ${GREEN}$BSC_BALANCE BNB${NC}"
echo -e "  Tensora (L2): ${GREEN}$L2_BALANCE BNB${NC}"
echo ""

# Prompt for amount
echo -e "${YELLOW}Enter amount to bridge (in BNB):${NC}"
read AMOUNT

# Confirm
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}⚡ Ready to bridge:${NC}"
echo -e "  Amount: ${GREEN}$AMOUNT BNB${NC}"
echo -e "  From:   ${GREEN}BSC Mainnet${NC}"
echo -e "  To:     ${GREEN}Tensora L2${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Press ENTER to confirm and start bridging...${NC}"
read

# Execute bridge transaction
echo ""
echo -e "${BLUE}🌉 Bridging $AMOUNT BNB from BSC to Tensora...${NC}"
echo ""

TX_HASH=$(cast send $BRIDGE_ADDR \
  "depositETH(uint32,bytes)" \
  200000 \
  "0x" \
  --value ${AMOUNT}ether \
  --rpc-url $BSC_RPC \
  --private-key "$PRIVATE_KEY" \
  --legacy 2>&1 | grep "transactionHash" | awk '{print $2}')

if [ -z "$TX_HASH" ]; then
    echo -e "${RED}❌ Bridge transaction failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Transaction submitted!${NC}"
echo -e "${GREEN}TX Hash: $TX_HASH${NC}"
echo -e "${GREEN}View on BSCScan: https://bscscan.com/tx/$TX_HASH${NC}"
echo ""

# Wait for deposit to appear on L2
echo -e "${BLUE}⏳ Waiting for deposit to appear on Tensora L2...${NC}"
echo ""

INITIAL_L2_BALANCE=$L2_BALANCE
for i in {1..24}; do
  sleep 5
  NEW_L2_BALANCE=$(cast balance $WALLET_ADDR --rpc-url $TENSORA_RPC --ether 2>/dev/null)
  
  echo -e "[${i}/24] L2 Balance: $NEW_L2_BALANCE BNB"
  
  # Check if balance increased
  if (( $(echo "$NEW_L2_BALANCE > $INITIAL_L2_BALANCE" | bc -l) )); then
    echo ""
    echo -e "${GREEN}🎉 SUCCESS! Deposit received on Tensora L2!${NC}"
    echo ""
    echo -e "${BLUE}📊 Final Balances:${NC}"
    echo -e "  BSC (L1):     ${GREEN}$(cast balance $WALLET_ADDR --rpc-url $BSC_RPC --ether) BNB${NC}"
    echo -e "  Tensora (L2): ${GREEN}$NEW_L2_BALANCE BNB${NC}"
    echo ""
    echo -e "${GREEN}✅ Bridge completed successfully!${NC}"
    exit 0
  fi
done

echo ""
echo -e "${YELLOW}⏱️  Still processing... Check your L2 balance in a few minutes${NC}"
echo -e "L2 RPC: $TENSORA_RPC"

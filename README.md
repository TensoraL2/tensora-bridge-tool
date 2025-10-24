# Tensora Bridge Script

A simple, secure command-line tool to bridge BNB from BSC Mainnet to Tensora L2.

## Features

✅ **Secure** - Private key input is hidden (no echo)  
✅ **Smart** - Auto-detects and adds "0x" prefix if needed  
✅ **Real-time** - Shows balances before and after bridging  
✅ **Automatic** - Waits and confirms when deposit arrives on L2  
✅ **User-friendly** - Colorful output with progress tracking  
✅ **Safe** - Confirmation required before executing transaction  

---

## Requirements

- `cast` (Foundry CLI) - [Install here](https://book.getfoundry.sh/getting-started/installation)
- `bc` - Basic calculator (usually pre-installed)
- Internet connection

---

## Installation

```bash
# Download the script
curl -O https://raw.githubusercontent.com/your-repo/bridge-to-tensora.sh

# Make it executable
chmod +x bridge-to-tensora.sh
```

---

## Usage

### Basic Usage

```bash
./bridge-to-tensora.sh
```

The script will guide you through:

1. **Enter Private Key** - Input is hidden for security
2. **View Balances** - See your current BSC and Tensora L2 balances
3. **Enter Amount** - Specify how much BNB to bridge
4. **Confirm** - Review and press ENTER to execute
5. **Wait** - Script automatically tracks deposit on L2

### Example Session

```
╔════════════════════════════════════════════════╗
║   TENSORA L2 - BSC to Tensora Bridge Tool     ║
╚════════════════════════════════════════════════╝

Enter your private key (with or without 0x):
[hidden input]

✅ Wallet: 0x5d0cC70C0558043b25C0854E40b3201db8A397d1

📊 Current Balances:
  BSC (L1):     0.5 BNB
  Tensora (L2): 0.011 BNB

Enter amount to bridge (in BNB):
0.05

════════════════════════════════════════════════
⚡ Ready to bridge:
  Amount: 0.05 BNB
  From:   BSC Mainnet
  To:     Tensora L2
════════════════════════════════════════════════

Press ENTER to confirm and start bridging...

🌉 Bridging 0.05 BNB from BSC to Tensora...

✅ Transaction submitted!
TX Hash: 0xabc123...
View on BSCScan: https://bscscan.com/tx/0xabc123...

⏳ Waiting for deposit to appear on Tensora L2...

[1/24] L2 Balance: 0.011 BNB
[2/24] L2 Balance: 0.011 BNB
[3/24] L2 Balance: 0.061 BNB

🎉 SUCCESS! Deposit received on Tensora L2!

📊 Final Balances:
  BSC (L1):     0.449 BNB
  Tensora (L2): 0.061 BNB

✅ Bridge completed successfully!
```

---

## Private Key Format

The script accepts **both formats**:

✅ **With 0x prefix:**
```
0x70eddd9d4d27390afa17932d629aad6a96bf0bb7142cbe05827b0aa7757d3143
```

✅ **Without 0x prefix:**
```
70eddd9d4d27390afa17932d629aad6a96bf0bb7142cbe05827b0aa7757d3143
```

The script will automatically add "0x" if missing.

---

## Network Details

### Tensora L2
- **Chain ID:** 44444444
- **RPC URL:** https://rpc2.tensora.sh
- **Block Time:** 1 second
- **Explorer:** https://explorer.tensora.sh

### BSC Mainnet (L1)
- **Chain ID:** 56
- **RPC URL:** https://bsc-dataseed.binance.org/
- **Explorer:** https://bscscan.com

### Bridge Contract
- **L1 Standard Bridge:** `0x0eAAF963708d34eB3b1459029782E820C596e438`
- **Deployment Block:** 65675835

---

## Security Notes

🔒 **Your private key is NEVER:**
- Displayed on screen
- Saved to disk
- Sent anywhere except to sign your transaction

🔒 **Best Practices:**
- Never share your private key
- Use a test wallet for initial trials
- Verify the bridge contract address before using
- Double-check the amount before confirming

---

## Troubleshooting

### "Invalid private key" Error
- Ensure your private key is 64 hex characters (with or without "0x")
- Check for any extra spaces or characters

### "Bridge transaction failed" Error
- Ensure you have enough BNB on BSC for the amount + gas fees
- Check your internet connection
- Verify BSC RPC is accessible

### Deposit Not Appearing on L2
- Wait up to 2 minutes for the deposit to be processed
- Check your transaction on [BSCScan](https://bscscan.com)
- Verify the transaction succeeded on L1

### "cast: command not found"
Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

---

## FAQ

**Q: How long does bridging take?**  
A: Typically 10-30 seconds for deposits to appear on L2.

**Q: Are there any fees?**  
A: You only pay BSC gas fees (~$0.10-0.30). No bridge fees!

**Q: What's the minimum/maximum bridge amount?**  
A: Minimum: 0.0001 BNB, Maximum: Limited by your balance

**Q: Can I bridge back from Tensora to BSC?**  
A: Yes! Use the Tensora bridge UI at https://bridge.tensora.sh (withdrawals take ~7 days for finalization)

**Q: Is this script safe?**  
A: Yes! It's open source and only uses standard Foundry tools. Your private key is used locally to sign transactions.

---

## Advanced Usage

### Bridge Without Confirmation Prompt

For automated scripts, you can pipe "yes":

```bash
echo -e "YOUR_PRIVATE_KEY\n0.01\n" | ./bridge-to-tensora.sh
```

⚠️ **Warning:** Only use in secure, automated environments

### Check Balances Only

Modify the script to exit before bridging:

```bash
# Add 'exit 0' after balance display
# Or just use cast directly:
cast balance YOUR_ADDRESS --rpc-url https://rpc2.tensora.sh --ether
```

---

## Support

- **Documentation:** https://docs.tensora.sh
- **Discord:** https://discord.gg/tensora
- **Twitter:** https://twitter.com/tensoraL2
- **Email:** support@tensora.sh

---

## License

MIT License - See LICENSE file for details

---

## Changelog

### v1.0.0 (2025-10-24)
- Initial release
- Support for both 0x and non-0x private key formats
- Real-time balance tracking
- Automatic L2 deposit confirmation
- Colorful CLI output

---

**Made with ❤️ by the Tensora Team**

*Bridge smart. Bridge fast. Bridge Tensora.*


# Tibia 7.4 Client Setup Guide

This guide provides instructions for obtaining and configuring Tibia 7.4 clients to work with your server.

## Option 1: OTClient (Recommended - Open Source & Legal)

**OTClient** is a free, open-source Tibia client that works perfectly with your TFS 7.4 server.

### Installation

1. **Download OTClient**
   - Visit: https://github.com/opentibiabr/otclient/releases
   - Download the latest release (version 4.0 or newer)
   - Choose your operating system (Windows, Linux, macOS)

2. **Extract and Run**
   ```bash
   # Extract the downloaded file
   unzip otclient-4.0-windows.zip
   cd otclient
   
   # Run the client
   ./otclient.exe  # Windows
   ./otclient      # Linux/macOS
   ```

3. **Configure for Tibia 7.4**
   - Launch OTClient
   - Go to Options → Game
   - Set Protocol Version: **7.4**
   - Server Address: `localhost` (or your server IP)
   - Server Port: `7171`

### Features
- ✅ Free and open-source
- ✅ Works with Tibia 7.4 servers
- ✅ Cross-platform (Windows, Linux, macOS)
- ✅ Actively maintained
- ✅ Modular and customizable
- ✅ Modern graphics and UI

---

## Option 2: Original Tibia 7.4 Client

The original Tibia 7.4 client is copyrighted by CIPSoft. Here are legal ways to obtain it:

### Where to Find It

1. **OTServList.org**
   - Visit: https://otservlist.org/download
   - Look for "Tibia 7.4" section
   - Download the client executable

2. **OTS-List.org**
   - Visit: https://ots-list.org/download
   - Search for "Tibia 7.4"
   - Multiple versions available

3. **Community Archives**
   - OTLand Forum: https://otland.net/
   - Search for "Tibia 7.4 Client"
   - Community members often share archived versions

4. **Your Own Archives**
   - If you have an old Tibia installation
   - Look for `Tibia.exe` from 2005-2006 era
   - Version 7.4 was released in that timeframe

### Installation

1. **Download the Client**
   - Get `Tibia.exe` (original Tibia 7.4 client)
   - File size: typically 50-100 MB

2. **Configure Server Connection**
   - Run `Tibia.exe`
   - The client will show login screen
   - You need to configure it to connect to your server

3. **Modify Client Configuration**
   
   **Option A: Using Cipsoft.dat (if available)**
   - Locate `Cipsoft.dat` in the client directory
   - Edit to point to your server IP
   - Save and restart client

   **Option B: Using Network Tools**
   - Use a network proxy tool to redirect connections
   - Redirect `login.tibia.com` to your server IP
   - Requires advanced networking knowledge

   **Option C: Using Hosts File**
   ```
   # Edit your system hosts file:
   # Windows: C:\Windows\System32\drivers\etc\hosts
   # Linux/Mac: /etc/hosts
   
   # Add this line:
   YOUR_SERVER_IP  login.tibia.com
   ```

---

## Comparison Table

| Feature | OTClient | Original Tibia 7.4 |
|---------|----------|-------------------|
| **Legal Status** | ✅ Open Source | ⚠️ Copyrighted |
| **Cost** | Free | Free (archived) |
| **Ease of Setup** | Very Easy | Moderate |
| **Cross-Platform** | ✅ Yes | ❌ Windows Only |
| **Customizable** | ✅ Yes | Limited |
| **Modern UI** | ✅ Yes | ❌ Legacy UI |
| **Active Development** | ✅ Yes | ❌ No |
| **Community Support** | ✅ Excellent | Limited |

---

## Recommended Setup

**For Best Experience:**
1. Use **OTClient** as your primary client
2. Keep **Original Tibia 7.4** as an alternative for authenticity
3. Both work perfectly with your TFS 7.4 server

---

## Troubleshooting

### Client Won't Connect

**Problem**: "Cannot connect to server"

**Solutions**:
1. Verify server is running: `docker-compose ps`
2. Check server logs: `docker-compose logs tfs`
3. Verify port forwarding (if connecting remotely)
4. Ensure firewall allows ports 7171 and 7172
5. Try `localhost` instead of IP for local testing

### Wrong Protocol Version

**Problem**: "Protocol version mismatch"

**Solutions**:
1. Verify client is set to version 7.4
2. Verify server config.lua has correct protocol
3. Ensure TFS is compiled for 7.4
4. Check OTClient configuration file

### Login Fails

**Problem**: "Invalid account or password"

**Solutions**:
1. Verify account exists in database
2. Check password is correct (testaccount/testpassword)
3. Verify MySQL is running: `docker-compose ps mysql`
4. Check database initialization: `./scripts/init-database.sh`

### Client Crashes

**Problem**: Client crashes on startup

**Solutions**:
1. Reinstall OTClient
2. Download latest version from GitHub
3. Check system requirements (RAM, GPU)
4. Verify graphics drivers are updated

---

## Advanced Configuration

### OTClient Mods

OTClient supports Lua-based mods for customization:

```lua
-- Example: Custom UI mod
-- Place in: data/mods/custom-ui/
-- Modify appearance, add features, etc.
```

### Server-Side Configuration

Adjust `config/config.lua` for client compatibility:

```lua
-- Protocol version
protocolVersion = 74

-- Client features
allowChangeOutfit = true
emoteSpells = false

-- Connection settings
maxPacketsPerSecond = 25
```

---

## Legal Notice

- **OTClient**: Licensed under MIT License - Free to use and modify
- **Original Tibia 7.4 Client**: Copyrighted by CIPSoft - Use for personal/private servers only
- **This Server**: Licensed under MIT License
- **The Forgotten Server**: Licensed under GNU GPL v2.0

---

## Support & Resources

- **OTClient GitHub**: https://github.com/opentibiabr/otclient
- **OTLand Community**: https://otland.net/
- **Server Documentation**: See docs/ directory
- **Troubleshooting**: Check server logs with `docker-compose logs`

---

## Next Steps

1. Download OTClient or original Tibia 7.4 client
2. Configure client for your server
3. Start your server: `docker-compose up -d`
4. Launch client and connect
5. Login with test account (testaccount/testpassword)
6. Enjoy your Tibia 7.4 experience!

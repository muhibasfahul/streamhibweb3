# 🚀 StreamHib Deployment Guide

## 📋 Current Status
✅ PostgreSQL installed and configured
✅ Database `streamhib` created
✅ PM2 installed
✅ System ready for StreamHib

## 🛠️ Next Steps

### 1. Upload Project Files
Upload all StreamHib files to `/root/streamhib/` directory:

```bash
cd /root
# Create directory if not exists
mkdir -p streamhib
cd streamhib

# Upload your project files here
# You can use SCP, SFTP, or Git clone
```

### 2. Run Setup Script
```bash
# Make setup script executable
chmod +x setup-streamhib.sh

# Run the setup
./setup-streamhib.sh
```

## 🎯 What the Setup Will Do

1. **Install Dependencies** - Frontend and backend npm packages
2. **Configure Environment** - Database connection and API keys
3. **Setup Database Tables** - Create all required tables with proper schema
4. **Build Frontend** - Create production build
5. **Start Services** - Launch backend and frontend with PM2
6. **Configure Nginx** - Setup reverse proxy for your domain
7. **Setup Firewall** - Allow necessary ports

## 📱 Access Points After Setup

- **Main Website**: http://ess.my.id
- **Admin Dashboard**: http://ess.my.id/admin
- **Member Area**: http://ess.my.id/member

## 👤 Default Login Credentials

- **Admin**: `admin@streamhib.com` / `admin123`
- **Test User**: `test@streamhib.com` / `test123`

## 🔧 Management Commands

```bash
# Check service status
pm2 status

# View logs
pm2 logs

# Restart services
pm2 restart all

# Check Nginx status
sudo systemctl status nginx

# Check database connection
sudo -u postgres psql streamhib
```

## 🚨 Troubleshooting

### If Database Issues
```bash
cd /root/streamhib/backend
node setup-database-final.js
```

### If Service Issues
```bash
pm2 restart all
sudo systemctl restart nginx
```

### Check Logs
```bash
# Backend logs
pm2 logs streamhib-backend

# Frontend logs  
pm2 logs streamhib-frontend

# Nginx logs
sudo tail -f /var/log/nginx/error.log
```

## 🎉 Features Ready

✅ **User Registration & Login**
✅ **Payment Integration** (Midtrans)
✅ **Admin Dashboard** 
✅ **Member Area**
✅ **Server Provisioning** (Hetzner)
✅ **Email Notifications**
✅ **Multi-language Support**
✅ **Responsive Design**

Your StreamHib platform will be fully operational after running the setup script! 🚀
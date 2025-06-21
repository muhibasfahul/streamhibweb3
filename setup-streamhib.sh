#!/bin/bash

echo "🚀 StreamHib Project Setup"
echo "=========================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Please run this script from the StreamHib project directory"
    exit 1
fi

print_header "1. Installing frontend dependencies..."
npm install

print_header "2. Installing backend dependencies..."
cd backend
npm install
cd ..

print_header "3. Setting up environment variables..."
cd backend

# Create .env file with your database password
cat > .env << 'EOF'
# Database
DATABASE_URL=postgresql://streamhib_user:streamhib123@localhost:5432/streamhib

# JWT Secret
JWT_SECRET=streamhib_super_secret_jwt_key_2025_very_long_and_secure

# Email Configuration (Gmail)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=streamhib@gmail.com
EMAIL_PASS=gzse ljrc yfrq ogwa

# Midtrans Payment Gateway
MIDTRANS_SERVER_KEY=SB-Mid-server-Y9ym1xDXthYjcEDtpJuN8I0X
MIDTRANS_CLIENT_KEY=SB-Mid-client-YnXAE6VufDGa3w61
MIDTRANS_MERCHANT_ID=G372974330
MIDTRANS_IS_PRODUCTION=false

# Hetzner Cloud API
HETZNER_API_TOKEN=NAcu7LsOjbUctpEBOsDztAJnvWYl9LIJlai5LbTaHVKfKlKkrFcXmMq4XHBzbxu8

# Application
NODE_ENV=production
PORT=3001
FRONTEND_URL=http://ess.my.id
EOF

print_status "Environment variables created!"

print_header "4. Setting up database tables..."
node setup-database-final.js

print_header "5. Building frontend..."
cd ..
npm run build

print_header "6. Setting up PM2 services..."
# Stop any existing services
pm2 delete all 2>/dev/null || true

cd backend
pm2 start app.js --name "streamhib-backend"
cd ..
pm2 serve out 3000 --name "streamhib-frontend"
pm2 save
pm2 startup

print_header "7. Configuring Nginx..."
cat > /etc/nginx/sites-available/streamhib << 'EOF'
server {
    listen 80;
    server_name ess.my.id;

    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/streamhib /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test and restart Nginx
nginx -t && systemctl restart nginx

print_header "8. Setting up firewall..."
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable

echo ""
echo "🎉 StreamHib setup completed!"
echo ""
echo "📋 Access Information:"
echo "   Website: http://ess.my.id"
echo "   Admin Dashboard: http://ess.my.id/admin"
echo "   Member Area: http://ess.my.id/member"
echo ""
echo "👤 Login Credentials:"
echo "   Admin: admin@streamhib.com / admin123"
echo "   Test User: test@streamhib.com / test123"
echo ""
echo "🔧 Useful Commands:"
echo "   Check logs: pm2 logs"
echo "   Restart services: pm2 restart all"
echo "   Check status: pm2 status"
echo "   Nginx logs: sudo tail -f /var/log/nginx/error.log"
echo ""
echo "🚀 Your StreamHib is now live!"
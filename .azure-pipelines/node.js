// server.js - Sample application with health check
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    region: process.env.REGION || 'unknown',
    environment: process.env.NODE_ENV || 'development',
    uptime: process.uptime()
  });
});

// API health endpoint for more detailed checks
app.get('/api/health', (req, res) => {
  // Add more comprehensive health checks here
  const healthCheck = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    region: process.env.REGION || 'unknown',
    environment: process.env.NODE_ENV || 'development',
    checks: {
      database: 'ok', // Add actual database check
      memory: process.memoryUsage(),
      uptime: process.uptime()
    }
  };

  res.status(200).json(healthCheck);
});

app.get('/', (req, res) => {
  res.json({
    message: 'Global Application Running',
    region: process.env.REGION || 'unknown',
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Region: ${process.env.REGION || 'unknown'}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
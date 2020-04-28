#!/bin/bash
echo "Content-Type:text/html"
echo ""
echo "<h1>ok</h1>"
echo "<h3>Prepare to update Blog Posts.....</h3>"
cd /my-blog/blog/
git pull | tee /my-blog/logs/genrate.log
nohup hexo g --debug >> /my-blog/logs/genrate.log 2>&1 &
echo "<p>Please view the <a href='logs.sh' target='_blank'>Logs</a></p>"
for RUBY_PROCESSES in `ps -ef |grep ruby | grep -v grep | awk {'print $2'}`; 
  do kill -9 $RUBY_PROCESSES;  
done
script/backgroundrb stop

[linux_servers]
%{ for ip in servers ~}
${ip}
%{ endfor ~}
[linux_servers:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user = ${ansible_user}
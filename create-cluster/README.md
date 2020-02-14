# Docs under construction




## Fixing /r errors in bash

Sometimes, if you edit the file on windows and then open in the linux container (through remote containers), you can have some issues with line-breaks when running the create-cluster script

for that, simply run the command below to fix the file:

```sed -i 's/\r$//' create-cluster.bash```
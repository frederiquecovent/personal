### **Datacenter Level Firewall Rules**
| Protocol | Source IP         | Source Port | Destination | Destination Port |
|----------|------------------|-------------|-------------|------------------|
| TCP      | [PUBLIC-IP]      | all         | all         | 80               |
| TCP      | [PUBLIC-IP]      | all         | all         | 443              |
| UDP      | all              | all         | all         | 53               |
| UDP      | all              | all         | 255.255.255.255 | 67           |
| TCP      | 192.168.0.152    | all         | all         | 22               |
| TCP      | 192.168.0.152    | all         | all         | 8006             |

### **VM Level Firewall Rules**
| Protocol | Source IP         | Source Port | Destination | Destination Port |
|----------|------------------|-------------|-------------|------------------|
| TCP      | [PUBLIC-IP]      | all         | all         | 80               |
| TCP      | [PUBLIC-IP]      | all         | all         | 443              |
| UDP      | all              | all         | all         | 53               |
| UDP      | all              | all         | 255.255.255.255 | 67           |
| TCP      | 10.10.1.1        | all         | all         | 22               |

#!/bin/sh
# 脚本作者@VanillaNahida
# 本文件是用于一键自动下载本项目所需文件，自动创建好目录
# 暂且只支持X86版本的Ubuntu系统，其他系统未测试

# 下载配置文件函数
check_and_download() {
    local filepath=$1
    local url=$2
    if [ ! -f "$filepath" ]; then
        if ! curl -fL --progress-bar "$url" -o "$filepath"; then
            whiptail --title "错误" --msgbox "${filepath}文件下载失败" 10 50
            exit 1
        fi
    else
        echo "${filepath}文件已存在，跳过下载"
    fi
}


# 检查curl安装
if ! command -v curl &> /dev/null; then
    echo "------------------------------------------------------------"
    echo "未检测到curl，正在安装..."
    apt update
    apt install -y curl
else
    echo "------------------------------------------------------------"
    echo "curl已安装，跳过安装步骤"
fi

if [ ! -d /opt/xiaozhi-server/data ]; then
    mkdir -p /opt/xiaozhi-server/data
    echo "已创建数据目录: /opt/xiaozhi-server/data"
else
    echo "目录xiaozhi-server/data已存在，跳过创建"
fi

# 检查并创建模型目录
if [ ! -d /opt/xiaozhi-server/models/SenseVoiceSmall ]; then
    mkdir -p /opt/xiaozhi-server/models/SenseVoiceSmall
    echo "已创建模型目录: /opt/xiaozhi-server/models/SenseVoiceSmall"
else
    echo "目录xiaozhi-server/models/SenseVoiceSmall已存在，跳过创建"
fi

if [ ! /opt/xiaozhi-server/data/.config.yaml ]; then
    cp config.yaml ./data/.config.yaml
else
    echo "skipi"
fi

echo "------------------------------------------------------------"
echo "Establishing ENV"

sed -i "s|<MQTT_GATEWAY>|'51.38.126.253:1883'|g" /opt/xiaozhi-server/data/.config.yaml
sed -i "s|<MQTT_SIGNATURE_KEY>|'test'|g" /opt/xiaozhi-server/data/.config.yaml
sed -i "s|<UDP_GATEWAY>|'51.38.126.253:8884'|g" /opt/xiaozhi-server/data/.config.yaml


echo "------------------------------------------------------------"
echo "开始下载语音识别模型"
# 下载模型文件
MODEL_PATH="/opt/xiaozhi-server/models/SenseVoiceSmall/model.pt"
if [ ! -f "$MODEL_PATH" ]; then
    (
    for i in {1..20}; do
        echo $((i*5))
        sleep 0.5
    done
    ) | whiptail --title "下载中" --gauge "开始下载语音识别模型..." 10 60 0
    curl -fL --progress-bar https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt -o "$MODEL_PATH" || {
        whiptail --title "错误" --msgbox "model.pt文件下载失败" 10 50
        exit 1
    }
else
    echo "model.pt文件已存在，跳过下载"
fi


python app.py

# 获取服务器公网地址
# PUBLIC_IP=$(hostname -I | awk '{print $1}')
# whiptail --title "配置服务器密钥" --msgbox "请使用浏览器，访问下方链接，打开智控台并注册账号: \n\n内网地址：http://127.0.0.1:8002/\n公网地址：http://$PUBLIC_IP:8002/ (若是云服务器请在服务器安全组放行端口 8000 8001 8002)。\n\n注册的第一个用户即是超级管理员，以后注册的用户都是普通用户。普通用户只能绑定设备和配置智能体; 超级管理员可以进行模型管理、用户管理、参数配置等功能。\n\n注册好后请按Enter键继续" 18 70
# SECRET_KEY=$(whiptail --title "配置服务器密钥" --inputbox "请使用超级管理员账号登录智控台\n内网地址：http://127.0.0.1:8002/\n公网地址：http://$PUBLIC_IP:8002/\n在顶部菜单 参数字典 → 参数管理 找到参数编码: server.secret (服务器密钥) \n复制该参数值并输入到下面输入框\n\n请输入密钥(留空则跳过配置):" 15 60 3>&1 1>&2 2>&3)

# if [ -n "$SECRET_KEY" ]; then
#     python3 -c "
# import sys, yaml; 
# config_path = '/opt/xiaozhi-server/data/.config.yaml'; 
# with open(config_path, 'r') as f: 
#     config = yaml.safe_load(f) or {}; 
# config['manager-api'] = {'url': 'http://xiaozhi-esp32-server-web:8002/xiaozhi', 'secret': '$SECRET_KEY'}; 
# with open(config_path, 'w') as f: 
#     yaml.dump(config, f); 
# "
#     docker restart xiaozhi-esp32-server
# fi

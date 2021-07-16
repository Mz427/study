#HTTPS通信过程:
#()私钥加密内容.
#{}公钥加密内容.
client-----------http request----------->server
                                     [key0, pub_key]
                                           |
                                           |
client<-------------pub_key--------------server
[pub_key]                            [key0, pub_key]
  |
  |
client--------------{key1}-------------->server
[pub_key, key1]                      [key0, pub_key, key1]
                                           |
                                           |
client<----------(http response)---------server #使用key1加密
[pub_key, key1]                      [key0, pub_key, key1]
  |
  |
#使用key1解密得到内容
#以上过程存在黑客冒充服务器通信漏洞.

#HTTPS+CA证书通信过程:
#()私钥加密内容.
#{}公钥加密内容.
client-----------http request----------->server<----------CA
                                     [key0, CA{证书内容, pub_key}]
                                           |
                                           |
client<------CA{证书内容, pub_key}-------server
[CA{证书内容, pub_key}]              [key0, CA{证书内容, pub_key}]
  |
#验证证书真实性
  |
client--------------{key1}-------------->server
[pub_key, key1]                      [key0, pub_key, key1]
                                           |
                                           |
client<----------(http response)---------server #使用key1加密
[pub_key, key1]                      [key0, pub_key, key1]
  |
  |
#使用key1解密得到内容
#以上过程存在黑客冒充服务器通信漏洞.

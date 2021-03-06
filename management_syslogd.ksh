##################################日志基础定义#################################
等級數值	等級名稱	    說明
7	        debug	        用來debug(除錯)時產生的訊息資料；
6	        info	        僅是一些基本的訊息說明而已；
5	        notice	        雖然是正常資訊，但比info還需要被注意到的一些資訊內容；
4	        warning(warn)   警示的訊息，可能有問題，但是還不至於影響到某個daemon運作的資訊；基本上， info, notice, warn這三個訊息都是在告知一些基本資訊而已，應該還不至於造成一些系統運作困擾； 
3	        err(error)      一些重大的錯誤訊息，例如設定檔的某些設定值造成該服務服法啟動的資訊說明， 通常藉由 err 的錯誤告知，應該可以瞭解到該服務無法啟動的問題呢！
2	        crit	        比error還要嚴重的錯誤資訊，這個crit是臨界點(critical)的縮寫，這個錯誤已經很嚴重了喔！
1	        alert	        警告警告，已經很有問題的等級，比crit還要嚴重！
0	        emerg(panic)    疼痛等級，意指系統已經幾乎要當機的狀態！ 很嚴重的錯誤資訊了。通常大概只有硬體出問題，導致整個核心無法順利運作，就會出現這樣的等級的訊息吧！

相對序號	服務類別	    說明
0	        kern(kernel)	就是核心(kernel)產生的訊息，大部分都是硬體偵測以及核心功能的啟用
1	        user	        在使用者層級所產生的資訊，例如後續會介紹到的用戶使用logger指令來記錄登錄檔的功能
2	        mail	        只要與郵件收發有關的訊息記錄都屬於這個；
3	        daemon	        主要是系統的服務所產生的資訊，例如systemd就是這個有關的訊息！
4	        auth	        主要與認證/授權有關的機制，例如login, ssh, su等需要帳號/密碼的咚咚；
5	        syslog	        就是由syslog相關協定產生的資訊，其實就是rsyslogd這支程式本身產生的資訊啊！
6	        lpr	            亦即是列印相關的訊息啊！
7	        news	        與新聞群組伺服器有關的東西；
8	        uucp	        全名為Unix to Unix Copy Protocol，早期用於unix系統間的程序資料交換；
9	        cron	        就是例行性工作排程cron/at等產生訊息記錄的地方；
10	        authpriv      	與auth類似，但記錄較多帳號私人的資訊，包括pam模組的運作等！
11	        ftp	            與FTP通訊協定有關的訊息輸出！
16~23	    local0 ~ local7	保留給本機用戶使用的一些登錄檔訊息，較常與終端機互動。

################################syslogd/rsyslogd使用的函数###############################
openlog() 
syslog() 
closelog()

##################################/etc/rsyslog.conf#################################
#kern.*                                              /dev/console
*.info;mail.none;authpriv.none;cron.none             /var/log/messages
authpriv.*                                           /var/log/secure
mail.*                                              -/var/log/maillog
cron.*                                               /var/log/cron
*.emerg                                              :omusrmsg:*
uucp,news.crit                                       /var/log/spooler
local7.*                                             /var/log/boot.log

#找到底下這幾行：
#Provides UDP syslog reception
#$ModLoad imudp
#$UDPServerRun 514

#Provides TCP syslog reception
#$ModLoad imtcp
#$InputTCPServerRun 514
#上面的是UDP埠口，底下的是TCP埠口！如果你的網路狀態很穩定，就用UDP即可。
#不過，如果你想要讓資料比較穩定傳輸，那麼建議使用TCP囉！所以修改底下兩行即可！

#################################/etc/logrotate.conf#################################
#底下的設定是"logrotate的預設設定值"，如果個別的檔案設定了其他的參數，
#則將以個別的檔案設定為主，若該檔案沒有設定到的參數則以這個檔案的內容為預設值！

weekly    <==預設每個禮拜對登錄檔進行一次rotate的工作
rotate 4  <==保留幾個登錄檔呢？預設是保留四個！
create    <==由於登錄檔被更名，因此建立一個新的來繼續儲存之意！
dateext   <==就是這個設定值！可以讓被輪替的檔案名稱加上日期作為檔名喔！
#compress <==被更動的登錄檔是否需要壓縮？如果登錄檔太大則可考慮此參數啟動

include /etc/logrotate.d
#將/etc/logrotate.d/這個目錄中的所有檔案都讀進來執行rotate的工作！

/var/log/wtmp {       <==僅針對 /var/log/wtmp 所設定的參數
    monthly           <==每個月一次，取代每週！
    create 0664 root utmp <==指定新建檔案的權限與所屬帳號/群組
    minsize 1M        <==檔案容量一定要超過 1M 後才進行 rotate (略過時間參數)
    rotate 1          <==僅保留一個，亦即僅有 wtmp.1 保留而已。
}
#這個wtmp可記錄登入者與系統重新開機時的時間與來源主機及登入期間的時間。
#由於具有minsize的參數，因此不見得每個月一定會進行一次喔！要看檔案容量。
#由於僅保留一個登錄檔而已，不滿意的話可以將他改成rotate 5吧！

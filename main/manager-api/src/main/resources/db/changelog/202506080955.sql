-- Console enable wake word acceleration
update `sys_params` set param_value = 'Hi Xiaozhi;Hello Xiaozhi;Hey Xiaoai;Hello Xiaoxin;Hi Xiaoxin;Hey Xiaomei;Xiaolong Xiaolong;Hey Miaomiao;Xiaobin Xiaobin;Xiaobing Xiaobing;Hey Hello There' where param_code = 'wakeup_words';
update `sys_params` set param_value = 'true' where param_code = 'enable_wakeup_words_response_cache';

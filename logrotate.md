# /etc/logrotate.conf

|設定値|説明|備考|
|--:|:--|:--|
|daily|日次でログローテーションを行う|必須|
|weekly|週次でログローテーションを行う||
|monthly|月次でログローテーションを行う||
|rotate 90|90世代を保存|必須|
|dateext|ログローテーションを行う際、ファイル末尾に日付を付与|必須|
|compress|ログローテーションを行う際、gzipにて圧縮|必須|
|delaycompress|ログの圧縮を次回のローテーション時まで遅らせる。<br>compressと共に指定。|必須|
|missingok|ログファイルが存在しなくてもエラーを出さずに処理を続行|必須|
|ifempty|ログファイルが空ローテーションする|必須|
|sharedscripts|複数指定したログファイル(`*log`など)に対し、<br>postrotateまたはprerotateで記述したコマンドを実行|必須|








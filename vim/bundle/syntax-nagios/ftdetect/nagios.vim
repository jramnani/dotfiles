au BufNewFile,BufRead /*etc/nagios/*.cfg,*sample-config/template-object/*.cfg{,.in},/var/lib/nagios/objects.cache set filetype=nagios
" For Nagios config files in Chef.
au BufNewFile,BufRead /*cookbooks/nagios/templates/default/*.cfg.erb set filetype=nagios

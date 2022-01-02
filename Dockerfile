FROM alpine:3.15

# Install packages
RUN apk --update --no-cache add \
  coreutils dumb-init findutils logrotate \
  munin nginx perl-cgi-fast procps \
  rrdtool-cached spawn-fcgi sudo openssl \
  ttf-opensans tzdata ssmtp mailx patch \
 && sed '/^[^*].*$/d; s/ munin //g' /etc/munin/munin.cron.sample | crontab -u munin -  \
 && sed -i 's#^log_file.*#log_file /dev/stdout#' /etc/munin/munin-node.conf \
 && sed -i 's|^root|#root|' /etc/ssmtp/ssmtp.conf \
 && ln -s /usr/sbin/ssmtp /usr/lib/sendmail \
# && ln -s /usr/sbin/ssmtp /usr/sbin/sendmail \
 && sed -i -r -e 's|formatted_value = sprintf "%.2f",|formatted_value = sprintf "%.4f",|' /usr/share/perl5/vendor_perl/Munin/Master/LimitsOld.pm \
 && cd /usr/lib/munin/plugins \
 && printf '\
LS0tIHBvc3RmaXhfbWFpbHN0YXRzCisrKyBwb3N0Zml4X21haWxzdGF0cwpAQCAtMTk1LDYgKzE5NSw3IEBAIHN1YiBwYXJzZUxvZ2ZpbGUKICAgICAgICAgfQogICAgICAgICBlbHNpZiAoJGxpbmUgPX4gL3Bvc3RmaXhcL3NtdHBkLipwcm94eS1yZWplY3Q6IFxTKyAoXFMrKS8gfHwKICAgICAgICAgICAgICAgICRsaW5lID1+IC9wb3N0Zml4XC9zbXRwZC4qcmVqZWN0OiBcUysgXFMrIFxTKyAoXFMrKS8gfHwKKyAgICAgICAgICAgICAgICRsaW5lID1+IC9wb3N0Zml4XC9wb3N0c2NyZWVuLipyZWplY3Q6IFxTKyBcUysgXFMrIChcUyspLyB8fAogICAgICAgICAgICAgICAgJGxpbmUgPX4gL3Bvc3RmaXhcL2NsZWFudXAuKiByZWplY3Q6IChcUyspLyB8fAog\
ICAgICAgICAgICAgICAgJGxpbmUgPX4gL3Bvc3RmaXhcL2NsZWFudXAuKiBtaWx0ZXItcmVqZWN0OiBcUysgXFMrIFxTKyAoXFMrKS8pCiAgICAgICAgIHsKLS0tIC9kZXYvbnVsbAorKysgc3NsLWNlcnRpZmljYXRlLWV4cGlyeQpAQCAtMCwwICsxLDIyNyBAQAorIyEvYmluL3NoIC11CisjIC0qLSBzaCAtKi0KKyMgc2hlbGxjaGVjayBkaXNhYmxlPVNDMjAzOQorCis6IDw8ID1jdXQKKworPWhlYWQxIE5BTUUKKworc3NsLWNlcnRpZmljYXRlLWV4cGlyeSAtIFBsdWdpbiB0byBtb25pdG9yIENlcnRpZmljYXRlIGV4cGlyYXRpb24gb24gbXVsdGlwbGUgc2VydmljZXMgYW5kIHBvcnRzCisKKz1oZWFkMSBDT05GSUdVUkFUSU9OCisKKyAgW3NzbC1jZXJ0aWZp\
Y2F0ZS1leHBpcnldCisgICAgZW52LnNlcnZpY2VzIHd3dy5zZXJ2aWNlLnRsZCBibGFoLmV4YW1wbGUubmV0X1BPUlQgZm9vLmV4YW1wbGUubmV0X1BPUlRfU1RBUlRUTFMKKworUE9SVCBpcyB0aGUgVENQIHBvcnQgbnVtYmVyCitTVEFSVFRMUyBpcyBwYXNzZWQgdG8gb3BlbnNzbCBhcyAiLXN0YXJ0dGxzIiBhcmd1bWVudC4gVXNlZnVsIGZvciBzZXJ2aWNlcyBsaWtlIFNNVFAgb3IgSU1BUCBpbXBsZW1lbnRpbmcgU3RhcnRUTFMuCisgIEN1cnJlbnQga25vd24gdmFsdWVzIGFyZSBmdHAsIGltYXAsIHBvcDMgYW5kIHNtdHAKKyAgUE9SVCBpcyBtYW5kYXRvcnkgaWYgU1RBUlRUTFMgaXMgdXNlZC4KKworVG8gc2V0IHdhcm5pbmcgYW5kIGNyaXRpY2FsIGxl\
dmVscyBkbyBsaWtlIHRoaXM6CisKKyAgW3NzbC1jZXJ0aWZpY2F0ZS1leHBpcnldCisgICAgZW52LnNlcnZpY2VzIC4uLgorICAgIGVudi53YXJuaW5nIDMwOgorICAgIGVudi5wcm94eSBQUk9YWUhPU1Q6UE9SVCAgICAgICAgICAjIG9wdGlvbmFsLCBlbmFibGVzIG9wZW5zc2wgb3BlcmF0aW9uIG92ZXIgcHJveHkKKyAgICBlbnYuY2hlY2tuYW1lIHllcyAgICAgICAgICAgICAgICAgIyBvcHRpb25hbCwgY2hlY2tzIGlmIHVzZWQgc2VydmVybmFtZSBpcyBjb3ZlcmVkIGJ5IGNlcnRpZmljYXRlCisKK0FsdGVybmF0aXZlbHksIGlmIHlvdSB3YW50IHRvIG1vbml0b3IgaG9zdHMgc2VwYXJhdGVseSwgeW91IGNhbiBjcmVhdGUgbXVsdGlwbGUgc3ltbGlua3Mg\
bmFtZWQgYXMgZm9sbG93cy4KKworICBzc2wtY2VydGlmaWNhdGUtZXhwaXJ5X0hPU1RfUE9SVAorCitGb3IgZXhhbXBsZToKKworICBzc2wtY2VydGlmaWNhdGUtZXhwaXJ5X3d3dy5leGFtcGxlLm5ldAorICBzc2wtY2VydGlmaWNhdGUtZXhwaXJ5X3d3dy5leGFtcGxlLm9yZ180NDMKKyAgc3NsLWNlcnRpZmljYXRlLWV4cGlyeV8xOTIuMC4yLjQyXzYzNgorICBzc2wtY2VydGlmaWNhdGUtZXhwaXJ5XzIwMDE6MERCODo6YmFkYzowZmVlXzQ4NQorICBzc2wtY2VydGlmaWNhdGUtZXhwaXJ5X21haWwuZXhhbXBsZS5uZXRfMjVfc210cAorCis9aGVhZDIgQ3JvbiBzZXR1cAorCitUbyBhdm9pZCBoYXZpbmcgdG8gcnVuIHRoZSBTU0wgY2hlY2tzIGR1cmluZyB0\
aGUgbXVuaW4tdXBkYXRlLCBpdCBpcyBwb3NzaWJsZQordG8gcnVuIGl0IGZyb20gY3JvbiwgYW5kIHNhdmUgYSBjYWNoZWZpbGUgdG8gYmUgcmVhZCBkdXJpbmcgdGhlIHVwZGF0ZSwgVGhpcyBpcworcGFydGljdWxhcmx5IHVzZWZ1bCB3aGVuIGNoZWNraW5nIGEgbGFyZ2UgbnVtYmVyIG9mIGNlcnRpZmljYXRlcywgb3Igd2hlbiBzb21lCitvZiB0aGUgaG9zdHMgYXJlIHNsb3cuCisKK1RvIGRvIHNvLCBhZGQgYSBjcm9uIGpvYiBydW5uaW5nIHRoZSBwbHVnaW4gd2l0aCBjcm9uIGFzIHRoZSBhcmd1bWVudDoKKworICA8bWludXRlPiAqICogKiA8dXNlcj4gL3Vzci9zYmluL211bmluLXJ1bi9zc2wtY2VydGlmaWNhdGUtZXhwaXJ5IGNyb24KKworPHVzZXI+\
IHNob3VsZCBiZSB0aGUgdXNlciB0aGF0IGhhcyB3cml0ZSBwZXJtaXNzaW9uIHRvIHRoZSBNVU5JTl9QTFVHU1RBVEUuCis8bWludXRlPiBzaG91bGQgYmUgYSBudW1iZXIgYmV0d2VlbiAwIGFuZCA1OSB3aGVuIHRoZSBjaGVjayBzaG91bGQgcnVuIGV2ZXJ5IGhvdXIuCisKK0lmLCBmb3IgYW55IHJlYXNvbiwgdGhlIGNyb24gc2NyaXB0IHN0b3BzIHJ1bm5pbmcsIHRoZSBzY3JpcHQgd2lsbCByZXZlcnQgdG8KK3VuY2FjaGVkIHVwZGF0ZXMgYWZ0ZXIgdGhlIGNhY2hlIGZpbGUgaXMgb2xkZXIgdGhhbiBhbiBob3VyLgorCis9aGVhZDEgQVVUSE9SUworCisgKiBQYWN0cmljayBEb21hY2sgKHNzbF8pCisgKiBPbGl2aWVyIE1laGFuaSAoc3NsLWNlcnRpZmlj\
YXRlLWV4cGlyeSkKKyAqIE1hcnRpbiBTY2hvYmVydCAoY2hlY2sgZm9yIGludGVybWVkaWF0ZSBjZXJ0cykKKyAqIEFybmR0IEtyaXR6bmVyIChob3N0bmFtZSB2ZXJpZmljYXRpb24gYW5kIHByb3h5IHVzYWdlKQorIAorICogQ29weXJpZ2h0IChDKSAyMDEzIFBhdHJpY2sgRG9tYWNrIDxwYXRyaWNrZGtAcGF0cmlja2RrLmNvbT4KKyAqIENvcHlyaWdodCAoQykgMjAxNywgMjAxOSBPbGl2aWVyIE1laGFuaSA8c2h0cm9tK211bmluQHNzamkubmV0PgorICogQ29weXJpZ2h0IChDKSAyMDIwIE1hcnRpbiBTY2hvYmVydCA8bWFydGluQHNjaG9iZXJ0LmNjPiAKKworPWhlYWQxIExJQ0VOU0UKKworPWN1dAorCisjIHNoZWxsY2hlY2sgZGlzYWJsZT1TQzEwOTAK\
Ky4gIiR7TVVOSU5fTElCRElSfS9wbHVnaW5zL3BsdWdpbi5zaCIKKworaWYgWyAiJHtNVU5JTl9ERUJVRzotMH0iID0gMSBdOyB0aGVuCisgICAgc2V0IC14CitmaQorCitIT1NUUE9SVD0kezAjIypzc2wtY2VydGlmaWNhdGUtZXhwaXJ5X30KK0NBQ0hFRklMRT0iJHtNVU5JTl9QTFVHU1RBVEV9LyQoYmFzZW5hbWUgIiR7MH0iKS5jYWNoZSIKKworaWYgWyAiJHtIT1NUUE9SVH0iICE9ICIkezB9IiBdIFwKKwkmJiBbIC1uICIke0hPU1RQT1JUfSIgXTsgdGhlbgorCXNlcnZpY2VzPSIke0hPU1RQT1JUfSIKK2ZpCisKKworIyBSZWFkIGRhdGEgaW5jbHVkaW5nIGEgY2VydGlmaWNhdGUgZnJvbSBzdGRpbiBhbmQgb3V0cHV0IHRoZSAoZnJhY3Rpb25hbCkgbnVt\
YmVyIG9mIGRheXMgbGVmdAorIyB1bnRpbCB0aGUgZXhwaXJ5IG9mIHRoaXMgY2VydGlmaWNhdGUuIFRoZSBvdXRwdXQgaXMgZW1wdHkgaWYgcGFyc2luZyBmYWlsZWQuCitwYXJzZV92YWxpZF9kYXlzX2Zyb21fY2VydGlmaWNhdGUoKSB7CisgICAgbG9jYWwgaW5wdXRfZGF0YQorICAgIGxvY2FsIHZhbGlkX3VudGlsX3N0cmluZworICAgIGxvY2FsIHZhbGlkX3VudGlsX2Vwb2NoCisgICAgbG9jYWwgbm93X2Vwb2NoCisgICAgbG9jYWwgaW5wdXRfZGF0YQorICAgIGlucHV0X2RhdGE9JChjYXQpCisKKyAgICBpZiBlY2hvICIkaW5wdXRfZGF0YSIgfCBncmVwIC1xIC0tICItLS0tLUJFR0lOIENFUlRJRklDQVRFLS0tLS0iOyB0aGVuCisgICAgICAgIHZhbGlk\
X3VudGlsX3N0cmluZz0kKGVjaG8gIiRpbnB1dF9kYXRhIiB8IG9wZW5zc2wgeDUwOSAtbm9vdXQgLWVuZGRhdGUgXAorICAgICAgICAgICAgfCBncmVwICJebm90QWZ0ZXI9IiB8IGN1dCAtZiAyIC1kICI9IikKKyAgICAgICAgaWYgWyAtbiAiJHZhbGlkX3VudGlsX3N0cmluZyIgXTsgdGhlbgorICAgICAgICAgICAgIyBGcmVlQlNEIHJlcXVpcmVzIHNwZWNpYWwgYXJndW1lbnRzIGZvciAiZGF0ZSIKKyAgICAgICAgICAgIGlmIHVuYW1lIHwgZ3JlcCAtcSBeRnJlZUJTRDsgdGhlbgorICAgICAgICAgICAgICAgIHZhbGlkX3VudGlsX2Vwb2NoPSQoZGF0ZSAtaiAtZiAnJWIgJWUgJVQgJVkgJVonICIkdmFsaWRfdW50aWxfc3RyaW5nIiArJXMpCisgICAgICAg\
ICAgICAgICAgbm93X2Vwb2NoPSQoZGF0ZSAtaiArJXMpCisgICAgICAgICAgICBlbHNlCisgICAgICAgICAgICAgICAgdmFsaWRfdW50aWxfZXBvY2g9JChkYXRlIC0tZGF0ZT0iJHZhbGlkX3VudGlsX3N0cmluZyIgKyVzKQorICAgICAgICAgICAgICAgIG5vd19lcG9jaD0kKGRhdGUgKyVzKQorICAgICAgICAgICAgZmkKKyAgICAgICAgICAgIGlmIFsgLW4gIiR2YWxpZF91bnRpbF9lcG9jaCIgXTsgdGhlbgorICAgICAgICAgICAgICAgICMgY2FsY3VsYXRlIHRoZSBudW1iZXIgb2YgZGF5cyBsZWZ0CisgICAgICAgICAgICAgICAgZWNobyAiJHZhbGlkX3VudGlsX2Vwb2NoIiAiJG5vd19lcG9jaCIgfCBhd2sgJ3sgcHJpbnQoKCQxIC0gJDIpIC8gKDI0ICog\
MzYwMCkpOyB9JworICAgICAgICAgICAgZmkKKyAgICAgICAgZmkKKyAgICBmaQorfQorCisKK3ByaW50X2V4cGlyZV9kYXlzKCkgeworICAgIGxvY2FsIGhvc3Q9IiQxIgorICAgIGxvY2FsIHBvcnQ9IiQyIgorICAgIGxvY2FsIHN0YXJ0dGxzPSIkMyIKKworICAgICMgV3JhcCBJUHY2IGFkZHJlc3NlcyBpbiBzcXVhcmUgYnJhY2tldHMKKyAgICBlY2hvICIkaG9zdCIgfCBncmVwIC1xICc6JyAmJiBob3N0PSJbJGhvc3RdIgorCisgICAgbG9jYWwgc19jbGllbnRfYXJncz0nJworICAgIFsgLW4gIiRzdGFydHRscyIgXSAmJiBzX2NsaWVudF9hcmdzPSIkc19jbGllbnRfYXJncyAtc3RhcnR0bHMgJHN0YXJ0dGxzIgorICAgIFsgLW4gIiR7cHJveHk6LX0iIF0g\
JiYgc19jbGllbnRfYXJncz0iJHNfY2xpZW50X2FyZ3MgLXByb3h5ICRwcm94eSIKKyAgICBbIC1uICIke2NoZWNrbmFtZTotfSIgXSAmJiBbICIkY2hlY2tuYW1lIiA9ICJ5ZXMiIF0gJiYgc19jbGllbnRfYXJncz0iJHNfY2xpZW50X2FyZ3MgLXZlcmlmeV9ob3N0bmFtZSAkaG9zdCIKKworICAgICMgV2UgZXh0cmFjdCBhbmQgY2hlY2sgdGhlIHNlcnZlciBjZXJ0aWZpY2F0ZSwKKyAgICAjIGJ1dCB0aGUgZW5kIGRhdGUgYWxzbyBkZXBlbmRzIG9uIGludGVybWVkaWF0ZSBjZXJ0cy4gVGhlcmVmb3JlCisgICAgIyB3ZSB3YW50IHRvIGNoZWNrIGludGVybWVkaWF0ZSBjZXJ0cyBhcyB3ZWxsLgorICAgICMKKyAgICAjIFRoZSBmb2xsb3dpbmcgY3J5cHRpYyBs\
aW5lcyBkbzoKKyAgICAjIC0gaW52b2tlIG9wZW5zc2wgYW5kIGNvbm5lY3QgdG8gYSBwb3J0CisgICAgIyAtIHByaW50IGNlcnRzLCBub3Qgb25seSB0aGUgc2VydmVyIGNlcnQKKyAgICAjIC0gZXh0cmFjdCBlYWNoIGNlcnRpZmljYXRlIGFzIGEgc2luZ2xlIGxpbmUKKyAgICAjIC0gcGlwZSBlYWNoIGNlcnQgdG8gdGhlIHBhcnNlX3ZhbGlkX2RheXNfZnJvbV9jZXJ0aWZpY2F0ZQorICAgICMgICBmdW5jdGlvbiwgd2hpY2ggYmFzaWNhbGx5IGlzICdvcGVuc3NsIHg1MDkgLWVuZGRhdGUnCisgICAgIyAtIGdldCBhIGxpc3Qgb2YgdGhlIHBhcnNlX3ZhbGlkX2RheXNfZnJvbV9jZXJ0aWZpY2F0ZQorICAgICMgICByZXN1bHRzIGFuZCBzb3J0IHRoZW0KKyAg\
ICAKKyAgICBsb2NhbCBvcGVuc3NsX2NhbGwKKyAgICBsb2NhbCBvcGVuc3NsX3Jlc3BvbnNlCisgICAgIyBzaGVsbGNoZWNrIGRpc2FibGU9U0MyMDg2CisgICAgb3BlbnNzbF9jYWxsPSJzX2NsaWVudCAtc2VydmVybmFtZSAkaG9zdCAtY29ubmVjdCAke2hvc3R9OiR7cG9ydH0gLXNob3djZXJ0cyAkc19jbGllbnRfYXJncyIKKyAgICAjIHNoZWxsY2hlY2sgZGlzYWJsZT1TQzIwODYKKyAgICBvcGVuc3NsX3Jlc3BvbnNlPSQoZWNobyAiIiB8IG9wZW5zc2wgJHtvcGVuc3NsX2NhbGx9IDI+L2Rldi9udWxsKQorICAgIGlmIGVjaG8gIiRvcGVuc3NsX3Jlc3BvbnNlIiB8IGdyZXAgLXFpICJIb3N0bmFtZSBtaXNtYXRjaCI7IHRoZW4KKwllY2hvICI8PiIKKyAg\
ICBlbHNlCisJZWNobyAiJG9wZW5zc2xfcmVzcG9uc2UiIHwgXAorCWF3ayAneworICAJICBpZiAoJDAgPT0gIi0tLS0tQkVHSU4gQ0VSVElGSUNBVEUtLS0tLSIpIGNlcnQ9IiIKKyAgCSAgZWxzZSBpZiAoJDAgPT0gIi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0iKSBwcmludCBjZXJ0CisgIAkgIGVsc2UgY2VydD1jZXJ0JDAKKwkgIH0nIHwgXAorCSAgd2hpbGUgcmVhZCAtciBDRVJUOyBkbworCSAgICAgIChwcmludGYgJ1xuLS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tXG4lc1xuLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLVxuJyAiJENFUlQiKSB8IFwKKwkgIAkgIHBhcnNlX3ZhbGlkX2RheXNfZnJvbV9jZXJ0aWZpY2F0ZQorICAgICAgICAgIGRvbmUg\
fCBzb3J0IC1uIHwgaGVhZCAtbiAxCisgICAgZmkKK30KKworbXlfY2xlYW5fZmllbGRuYW1lKCkgeworICAgICMgaWYgYSBkb21haW4gc3RhcnRzIHdpdGggYSBkaWdpdCwgb3IgaXRzIGFuIElQIGFkZHJlc3MsIHByZXBlbmQgJ18nCisgICAgY2xlYW5fZmllbGRuYW1lICIkKGVjaG8gIiRAIiB8IHNlZCAtRSAncy9eKFswLTldKS9fXDEvJykiCit9CisKK21haW4oKSB7CisgICAgZm9yIHNlcnZpY2UgaW4gJHNlcnZpY2VzOyBkbworCWlmIGVjaG8gIiRzZXJ2aWNlIiB8IGdyZXAgLXEgIl8iOyB0aGVuCisJICAgIGhvc3Q9JChlY2hvICIkc2VydmljZSIgfCBjdXQgLWYgMSAtZCAiXyIpCisJICAgIHBvcnQ9JChlY2hvICIkc2VydmljZSIgfCBjdXQgLWYgMiAt\
ZCAiXyIpCisJICAgIHN0YXJ0dGxzPSQoZWNobyAiJHNlcnZpY2UiIHwgY3V0IC1mIDMgLWQgIl8iKQorCWVsc2UKKwkgICAgaG9zdD0kc2VydmljZQorCSAgICBwb3J0PTQ0MworCSAgICBzdGFydHRscz0iIgorCWZpCisJZmllbGRuYW1lPSIkKG15X2NsZWFuX2ZpZWxkbmFtZSAiJHNlcnZpY2UiKSIKKwl2YWxpZF9kYXlzPSQocHJpbnRfZXhwaXJlX2RheXMgIiRob3N0IiAiJHBvcnQiICIkc3RhcnR0bHMiKQorCWV4dGluZm89IiIKKwlbIC16ICIkdmFsaWRfZGF5cyIgXSAmJiB2YWxpZF9kYXlzPSJVIgorCWlmIFsgIiR2YWxpZF9kYXlzIiA9ICI8PiIgXTsgdGhlbgorCSAgICBleHRpbmZvPSJFcnJvcjogaG9zdG5hbWUgbWlzbWF0Y2gsICIKKwkgICAgdmFs\
aWRfZGF5cz0iLTEiCisJZmkKKwlwcmludGYgIiVzLnZhbHVlICVzXFxuIiAiJGZpZWxkbmFtZSIgIiR2YWxpZF9kYXlzIgorCWVjaG8gIiR7ZmllbGRuYW1lfS5leHRpbmZvICR7ZXh0aW5mb31MYXN0IGNoZWNrZWQ6ICQoZGF0ZSkiCisgICAgZG9uZQorfQorCitjYXNlICR7MTotfSBpbgorICAgIGNvbmZpZykKKwllY2hvICJncmFwaF90aXRsZSBTU0wgQ2VydGlmaWNhdGVzIEV4cGlyYXRpb24iCisJZWNobyAnZ3JhcGhfYXJncyAtLWJhc2UgMTAwMCcKKwllY2hvICdncmFwaF92bGFiZWwgZGF5cyBsZWZ0JworCWVjaG8gJ2dyYXBoX2NhdGVnb3J5IHNlY3VyaXR5JworCWVjaG8gImdyYXBoX2luZm8gVGhpcyBncmFwaCBzaG93cyB0aGUgbnVtYmVycyBvZiBk\
YXlzIGJlZm9yZSBjZXJ0aWZpY2F0ZSBleHBpcnkiCisJZm9yIHNlcnZpY2UgaW4gJHNlcnZpY2VzOyBkbworCSAgICBmaWVsZG5hbWU9JChteV9jbGVhbl9maWVsZG5hbWUgIiRzZXJ2aWNlIikKKwkgICAgZWNobyAiJHtmaWVsZG5hbWV9LmxhYmVsICQoZWNobyAiJHtzZXJ2aWNlfSIgfCBzZWQgJ3MvXy86LycpIgorCSAgICBwcmludF90aHJlc2hvbGRzICIke2ZpZWxkbmFtZX0iIHdhcm5pbmcgY3JpdGljYWwKKwlkb25lCisKKwlleGl0IDAKKwk7OworICAgIGNyb24pCisJVVBEQVRFPSIkKG1haW4pIgorCWVjaG8gIiR7VVBEQVRFfSIgPiAiJHtDQUNIRUZJTEV9IgorCWNobW9kIDA2NDQgIiR7Q0FDSEVGSUxFfSIKKworCWV4aXQgMAorCTs7Citlc2FjCisK\
K2lmIFsgLW4gIiQoZmluZCAiJHtDQUNIRUZJTEV9IiAtbW1pbiAtNjAgMj4vZGV2L251bGwpIiBdOyB0aGVuCisJY2F0ICIke0NBQ0hFRklMRX0iCisJZXhpdCAwCitmaQorCittYWluCisKLS0tIC9kZXYvbnVsbAorKysgc3NsX2V4cGlyZV8KQEAgLTAsMCArMSwxNTAgQEAKKyMhL2Jpbi9iYXNoCisjIC0qLSBzaCAtKi0KKworOiA8PCA9Y3V0CisKKz1oZWFkMSBOQU1FCisKK3NzbF9leHBpcmVfIC0gV2lsZGNhcmQtcGx1Z2luIHRvIG1vbml0b3Igc3NsIGNlcnRpZmljYXRlIGV4cGlyYXRpb24KKworPWhlYWQxIENPTkZJR1VSQVRJT04KKworVGhpcyBwbHVnaW4gZG9lcyBub3Qgbm9ybWFsbHkgcmVxdWlyZSBjb25maWd1cmF0aW9uLgorCitUbyBzZXQgd2Fy\
bmluZyBhbmQgY3JpdGljYWwgbGV2ZWxzIGRvIGxpa2UgdGhpczoKKworICBbc3NsX2V4cGlyZV8qXQorICAgIGVudi53YXJuaW5nIDYwOgorICAgIGVudi5jcml0aWNhbCAxNToKKyAgICBlbnYuY2FwYXRoIC9ldGMvc3NsL2NlcnRzCisKKz1oZWFkMSBBVVRIT1IKKworQ29weXJpZ2h0IChDKSAyMDIxIFBhdHJpY2sgRG9tYWNrIDxwYXRyaWNrZGtAcGF0cmlja2RrLmNvbT4KKworPWhlYWQxIExJQ0VOU0UKKworR1BMdjIKKworPWhlYWQxIE1BR0lDIE1BUktFUlMKKworICMlIyBmYW1pbHk9YXV0bworICMlIyBjYXBhYmlsaXRpZXM9YXV0b2NvbmYgc3VnZ2VzdAorCis9Y3V0CisKKy4gJE1VTklOX0xJQkRJUi9wbHVnaW5zL3BsdWdpbi5zaAorCitDQVBBVEg9\
JHtjYXBhdGg6LS9ldGMvc3NsL2NlcnRzfQorTUFYX1RJTUU9JHttYXhfdGltZTotMTB9CitQT1JUPSR7cG9ydDotNDQzfQorU0lURT0kezAjIypzc2xfZXhwaXJlX30KK1RZUEU9IiIKKworSUZTPV87IHJlYWQgLWEgc3RyIDw8PCAiJHtTSVRFfSI7CisKK2lmIFsgJHsjc3RyWypdfSAtZ3QgMSBdOyB0aGVuCisgIFNJVEU9JHtzdHJbMF19CisgIFBPUlQ9JHtzdHJbMV19CitmaQorCitjYXNlICRQT1JUIGluCisgIHNtdHApCisgICAgVFlQRT0ic210cCIKKyAgICA7OworICBzdWJtaXNzaW9uKQorICAgIFRZUEU9InNtdHAiCisgICAgOzsKKyAgMjUpCisgICAgVFlQRT0ic210cCIKKyAgICA7OworICA1ODcpCisgICAgVFlQRT0ic210cCIKKyAgICA7OworICBw\
b3AzKQorICAgIFRZUEU9InBvcDMiCisgICAgOzsKKyAgMTEwKQorICAgIFRZUEU9InBvcDMiCisgICAgOzsKKyAgaW1hcCkKKyAgICBUWVBFPSJpbWFwIgorICAgIDs7CisgIDE0MykKKyAgICBUWVBFPSJpbWFwIgorICAgIDs7CisgIG15c3FsKQorICAgIFRZUEU9Im15c3FsIgorICAgIDs7CisgIDMzMDYpCisgICAgVFlQRT0ibXlzcWwiCisgICAgOzsKKyAgbG10cCkKKyAgICBUWVBFPSJsbXRwIgorICAgIDs7CisgIDI0KQorICAgIFRZUEU9ImxtdHAiCisgICAgOzsKKyAgZnRwKQorICAgIFRZUEU9ImZ0cCIKKyAgICA7OworICAyMSkKKyAgICBUWVBFPSJmdHAiCisgICAgOzsKK2VzYWMKKworaWYgWyAkeyNzdHJbKl19IC1ndCAyIF07IHRoZW4KKyAgU0lU\
RT0ke3N0clswXX0KKyAgUE9SVD0ke3N0clsxXX0KKyAgVFlQRT0ke3N0clsyXX0KK2ZpCisKK2Nhc2UgJDEgaW4KKyAgICBjb25maWcpCisKKyAgICAgICAgZWNobyAiZ3JhcGhfdGl0bGUgJHtTSVRFfSBTU0wgQ2VydGlmaWNhdGUgRXhwaXJlIGZvciBQb3J0ICR7UE9SVH0iCisgICAgICAgIGVjaG8gJ2dyYXBoX2FyZ3MgLS1iYXNlIDEwMDAnCisgICAgICAgIGVjaG8gJ2dyYXBoX3ZsYWJlbCBkYXlzIGxlZnQnCisgICAgICAgIGVjaG8gJ2dyYXBoX2NhdGVnb3J5IHNzbCcKKyAgICAgICAgZWNobyAiZ3JhcGhfaW5mbyBUaGlzIGdyYXBoIHNob3dzIHRoZSBkYXlzIGxlZnQgZm9yIHRoZSBjZXJ0aWZpY2F0ZSBiZWluZyBzZXJ2ZWQgYnkgJHtTSVRFfSB1c2lu\
ZyBwb3J0ICR7UE9SVH0iCisgICAgICAgIGVjaG8gJ2V4cGlyZS5sYWJlbCBkYXlzJworICAgICAgICBwcmludF93YXJuaW5nIGV4cGlyZQorICAgICAgICBwcmludF9jcml0aWNhbCBleHBpcmUKKworICAgICAgICBleGl0IDAKKyAgICAgICAgOzsKK2VzYWMKKworY2FzZSAkVFlQRSBpbgorICBzbXRwKQorICAgIGNlcnQ9JChlY2hvICJxdWl0IiB8IHRpbWVvdXQgIiR7TUFYX1RJTUV9IiBvcGVuc3NsIHNfY2xpZW50IC12ZXJpZnlfaG9zdG5hbWUgLUNBcGF0aCAiJHtDQVBBVEh9IiAtc2VydmVybmFtZSAiJHtTSVRFfSIgLWNvbm5lY3QgIiR7U0lURX06JHtQT1JUfSIgLXN0YXJ0dGxzICR7VFlQRX0gMj4vZGV2L251bGwpOworICAgIDs7CisgIHBvcDMpCisg\
ICAgY2VydD0kKGVjaG8gInF1aXQiIHwgdGltZW91dCAiJHtNQVhfVElNRX0iIG9wZW5zc2wgc19jbGllbnQgLXZlcmlmeV9ob3N0bmFtZSAtQ0FwYXRoICIke0NBUEFUSH0iIC1zZXJ2ZXJuYW1lICIke1NJVEV9IiAtY29ubmVjdCAiJHtTSVRFfToke1BPUlR9IiAtc3RhcnR0bHMgJHtUWVBFfSAyPi9kZXYvbnVsbCk7CisgICAgOzsKKyAgaW1hcCkKKyAgICBjZXJ0PSQoZWNobyAiYSBsb2dvdXQiIHwgdGltZW91dCAiJHtNQVhfVElNRX0iIG9wZW5zc2wgc19jbGllbnQgLXZlcmlmeV9ob3N0bmFtZSAtQ0FwYXRoICIke0NBUEFUSH0iIC1zZXJ2ZXJuYW1lICIke1NJVEV9IiAtY29ubmVjdCAiJHtTSVRFfToke1BPUlR9IiAtc3RhcnR0bHMgJHtUWVBFfSAyPi9k\
ZXYvbnVsbCk7CisgICAgOzsKKyAgbXlzcWwpCisgICAgY2VydD0kKGVjaG8gIiIgfCB0aW1lb3V0ICIke01BWF9USU1FfSIgb3BlbnNzbCBzX2NsaWVudCAtdmVyaWZ5X2hvc3RuYW1lIC1DQXBhdGggIiR7Q0FQQVRIfSIgLXNlcnZlcm5hbWUgIiR7U0lURX0iIC1jb25uZWN0ICIke1NJVEV9OiR7UE9SVH0iIC1zdGFydHRscyAke1RZUEV9IDI+L2Rldi9udWxsKTsKKyAgICA7OworICBsbXRwKQorICAgIGNlcnQ9JChlY2hvICJxdWl0IiB8IHRpbWVvdXQgIiR7TUFYX1RJTUV9IiBvcGVuc3NsIHNfY2xpZW50IC12ZXJpZnlfaG9zdG5hbWUgLUNBcGF0aCAiJHtDQVBBVEh9IiAtc2VydmVybmFtZSAiJHtTSVRFfSIgLWNvbm5lY3QgIiR7U0lURX06JHtQT1JUfSIg\
LXN0YXJ0dGxzICR7VFlQRX0gMj4vZGV2L251bGwpOworICAgIDs7CisgIGZ0cCkKKyAgICBjZXJ0PSQoZWNobyAicXVpdCIgfCB0aW1lb3V0ICIke01BWF9USU1FfSIgb3BlbnNzbCBzX2NsaWVudCAtdmVyaWZ5X2hvc3RuYW1lIC1DQXBhdGggIiR7Q0FQQVRIfSIgLXNlcnZlcm5hbWUgIiR7U0lURX0iIC1jb25uZWN0ICIke1NJVEV9OiR7UE9SVH0iIC1zdGFydHRscyAke1RZUEV9IDI+L2Rldi9udWxsKTsKKyAgICA7OworICAqKQorICAgIGlmIFsgLXogIiR7VFlQRX0iIF07IHRoZW4KKyAgICAgIGNlcnQ9JChlY2hvICIiIHwgdGltZW91dCAiJHtNQVhfVElNRX0iIG9wZW5zc2wgc19jbGllbnQgLXZlcmlmeV9ob3N0bmFtZSAtQ0FwYXRoICIke0NBUEFUSH0i\
IC1zZXJ2ZXJuYW1lICIke1NJVEV9IiAtY29ubmVjdCAiJHtTSVRFfToke1BPUlR9IiAyPi9kZXYvbnVsbCk7CisgICAgZWxzZQorICAgICAgY2VydD0kKGVjaG8gIiIgfCB0aW1lb3V0ICIke01BWF9USU1FfSIgb3BlbnNzbCBzX2NsaWVudCAtdmVyaWZ5X2hvc3RuYW1lIC1DQXBhdGggIiR7Q0FQQVRIfSIgLXNlcnZlcm5hbWUgIiR7U0lURX0iIC1jb25uZWN0ICIke1NJVEV9OiR7UE9SVH0iIDI+L2Rldi9udWxsKTsKKyAgICBmaQorICAgIDs7Citlc2FjCisKKworaWYgW1sgIiR7Y2VydH0iID0gKiItLS0tLUJFR0lOIENFUlRJRklDQVRFLS0tLS0iKiBdXTsgdGhlbgorICBlY2hvICIke2NlcnR9IiB8IG9wZW5zc2wgeDUwOSAtbm9vdXQgLWVuZGRhdGUgfCBh\
d2sgLUY9ICdCRUdJTiB7IHNwbGl0KCJKYW4gRmViIE1hciBBcHIgTWF5IEp1biBKdWwgQXVnIFNlcCBPY3QgTm92IERlYyIsIG1vbnRoLCAiICIpOyBmb3IgKGk9MTsgaTw9MTI7IGkrKykgbWRpZ2l0W21vbnRoW2ldXSA9IGk7IH0gL25vdEFmdGVyLyB7IHNwbGl0KCQwLGEsIj0iKTsgc3BsaXQoYVsyXSxiLCIgIik7IHNwbGl0KGJbM10sdGltZSwiOiIpOyBkYXRldGltZT1iWzRdICIgIiBtZGlnaXRbYlsxXV0gIiAiIGJbMl0gIiAiIHRpbWVbMV0gIiAiIHRpbWVbMl0gIiAiIHRpbWVbM107IGRheXM9KG1rdGltZShkYXRldGltZSktc3lzdGltZSgpKS84NjQwMDsgcHJpbnQgImV4cGlyZS52YWx1ZSAiIGRheXM7IH0nCitmaQorCi0tLSBteXNxbF8KKysrIG15\
c3FsXwpAQCAtMTE5MSw3ICsxMTkxLDcgQEAgc3ViIHVwZGF0ZV9pbm5vZGIgewogICAgIG15ICRyb3cgPSAkc3RoLT5mZXRjaHJvd19oYXNocmVmKCk7CiAgICAgbXkgJHN0YXR1cyA9ICRyb3ctPnsnc3RhdHVzJ307CiAgICAgJHN0aC0+ZmluaXNoKCk7Ci0KKyAgICAkc3RhdHVzID1+IHMvLS0tLS0tLS0tLS0tLS0tLS1cbk1haW4gdGhyZWFkLy9nOyAjQWRkZWQgZml4IGZvciBwZXJjb25hPwogICAgIHBhcnNlX2lubm9kYl9zdGF0dXMoJHN0YXR1cyk7CiB9CiAKLS0tIHNubXBfX2lmXworKysgc25tcF9faWZfCkBAIC0xNzksNiArMTc5LDcgQEAgaWYgKCRBUkdWWzBdIGFuZCAkQVJHVlswXSBlcSAiY29uZmlnIikgewogICAgIH0KIAogICAgIG15ICR3YXJu\
ID0gdW5kZWY7CisgICAgbXkgJGNyaXQgPSB1bmRlZjsKICAgICBteSAkc3BlZWQgPSB1bmRlZjsKIAogICAgIGlmIChkZWZpbmVkICgkc3BlZWQgPSAkc2Vzc2lvbi0+Z2V0X3NpbmdsZSgkaWZFbnRyeVNwZWVkKSkpIHsKQEAgLTE5Nyw3ICsxOTgsOCBAQCBpZiAoJEFSR1ZbMF0gYW5kICRBUkdWWzBdIGVxICJjb25maWciKSB7CiAJCQkqIDEwMDAgKiAxMDAwOwogCX0KIAotCSR3YXJuID0gKCRzcGVlZC8xMCkqODsKKwkkd2FybiA9ICgkc3BlZWQvMTApKjY7CisJJGNyaXQgPSAoJHNwZWVkLzEwKSo4OwogCiAJIyBXYXJuIGF0IDEvOHRoIG9mIGFjdHVhbGwgc3BlZWQ/ICBPciBqdXN0IHJlbW92ZSB3YXJuaW5nPwogCSMgVGVtcHRlZCB0byBzZXQgd2Fybmlu\
ZyBhdCA4MCUuIDgwJSBvdmVyIDUgbWludXRlcyBpcyBwcmV0dHkKQEAgLTIzOCwxNCArMjQwLDE0IEBAIGlmICgkQVJHVlswXSBhbmQgJEFSR1ZbMF0gZXEgImNvbmZpZyIpIHsKICAgICBwcmludCAicmVjdi5jZGVmIHJlY3YsOCwqXG4iOwogICAgIHByaW50ICJyZWN2Lm1heCAkc3BlZWRcbiIgaWYgJHNwZWVkOwogICAgIHByaW50ICJyZWN2Lm1pbiAwXG4iOwotICAgIHByaW50ICJyZWN2Lndhcm5pbmcgIiwgKCR3YXJuKSwgIlxuIiBpZiBkZWZpbmVkICR3YXJuICYmICgkd2FybiAhPSAwKTsKKyAgICBwcmludF90aHJlc2hvbGRzKCJyZWN2Iix1bmRlZix1bmRlZiwkd2FybiwkY3JpdCkgaWYgZGVmaW5lZCAkd2FybiAmJiBkZWZpbmVkICRjcml0OwogICAg\
IHByaW50ICJzZW5kLmxhYmVsIGJwc1xuIjsKICAgICBwcmludCAic2VuZC50eXBlIERFUklWRVxuIjsKICAgICBwcmludCAic2VuZC5uZWdhdGl2ZSByZWN2XG4iOwogICAgIHByaW50ICJzZW5kLmNkZWYgc2VuZCw4LCpcbiI7CiAgICAgcHJpbnQgInNlbmQubWF4ICRzcGVlZFxuIiBpZiAkc3BlZWQ7CiAgICAgcHJpbnQgInNlbmQubWluIDBcbiI7Ci0gICAgcHJpbnQgInNlbmQud2FybmluZyAkd2FyblxuIiBpZiBkZWZpbmVkICR3YXJuICYmICgkd2FybiAhPSAwKTsKKyAgICBwcmludF90aHJlc2hvbGRzKCJzZW5kIix1bmRlZix1bmRlZiwkd2FybiwkY3JpdCkgaWYgZGVmaW5lZCAkd2FybiAmJiBkZWZpbmVkICRjcml0OwogICAgIGV4aXQgMDsKIH0KIAot\
LS0gc25tcF9faWZfZXJyXworKysgc25tcF9faWZfZXJyXwpAQCAtMTMxLDYgKzEzMSw3IEBAIGlmICgkQVJHVlswXSBhbmQgJEFSR1ZbMF0gZXEgImNvbmZpZyIpIHsKIAogICAgICMgQW55IGVycm9yIGlzIHRvbyBtYW55CiAgICAgbXkgJHdhcm4gPSAxOworICAgIG15ICRjcml0ID0gMTAwOwogCiAgICAgcHJpbnQgImdyYXBoX3RpdGxlIEludGVyZmFjZSAkYWxpYXMgZXJyb3JzXG4iOwogICAgIHByaW50ICJncmFwaF9vcmRlciByZWN2IHNlbmRcbiI7CkBAIC0xNDMsMTIgKzE0NCwxMiBAQCBpZiAoJEFSR1ZbMF0gYW5kICRBUkdWWzBdIGVxICJjb25maWciKSB7CiAgICAgcHJpbnQgInJlY3YudHlwZSBERVJJVkVcbiI7CiAgICAgcHJpbnQgInJlY3YuZ3Jh\
cGggbm9cbiI7CiAgICAgcHJpbnQgInJlY3YubWluIDBcbiI7Ci0gICAgcHJpbnQgInJlY3Yud2FybmluZyAiLCAoJHdhcm4pLCAiXG4iIGlmIGRlZmluZWQgJHdhcm47CisgICAgcHJpbnRfdGhyZXNob2xkcygicmVjdiIsdW5kZWYsdW5kZWYsJHdhcm4sJGNyaXQpIGlmIGRlZmluZWQgJHdhcm4gJiYgZGVmaW5lZCAkY3JpdDsKICAgICBwcmludCAic2VuZC5sYWJlbCBlcnJvcnNcbiI7CiAgICAgcHJpbnQgInNlbmQudHlwZSBERVJJVkVcbiI7CiAgICAgcHJpbnQgInNlbmQubmVnYXRpdmUgcmVjdlxuIjsKICAgICBwcmludCAic2VuZC5taW4gMFxuIjsKLSAgICBwcmludCAic2VuZC53YXJuaW5nICR3YXJuXG4iIGlmIGRlZmluZWQgJHdhcm47CisgICAgcHJp\
bnRfdGhyZXNob2xkcygic2VuZCIsdW5kZWYsdW5kZWYsJHdhcm4sJGNyaXQpIGlmIGRlZmluZWQgJHdhcm4gJiYgZGVmaW5lZCAkY3JpdDsKICAgICBleGl0IDA7CiB9CiAKLS0tIHNubXBfX2lmX211bHRpCisrKyBzbm1wX19pZl9tdWx0aQpAQCAtNjEzLDEyICs2MTMsMTQgQEAgc3ViIGRvX2NvbmZpZ19pZiB7CiAgICAgfQogCiAgICAgbXkgJHdhcm4gPSB1bmRlZjsKKyAgICBteSAkY3JpdCA9IHVuZGVmOwogICAgIG15ICRzcGVlZCA9IDA7CiAKICAgICBpZiAoZGVmaW5lZCAoJHNwZWVkID0gJHNubXBpbmZvWC0+eyRpZn0tPntpZkhpZ2hTcGVlZH0pIGFuZCAkc3BlZWQpIHsKICAgICAgICMgU3BlZWQgaW4gMSwwMDAsMDAwIGJpdHMgcGVyIHNlY29uZAog\
ICAgICAgJHNwZWVkID0gJHNwZWVkICogMTAwMDAwMDsKLSAgICAgICR3YXJuID0gJHNwZWVkICogNzUgLyAxMDA7CisgICAgICAkd2FybiA9ICRzcGVlZCAqIDYwIC8gMTAwOworICAgICAgJGNyaXQgPSAkc3BlZWQgKiA4MCAvIDEwMDsKIAogICAgICAgbXkgJHRleHRzcGVlZCA9IHNjYWxlTnVtYmVyKCRzcGVlZCwnYnBzJywnJywKIAkJCQkgICdUaGUgaW50ZXJmYWNlIHNwZWVkIGlzICUuMWYlcyVzLicpOwpAQCAtNjI2LDcgKzYyOCw4IEBAIHN1YiBkb19jb25maWdfaWYgewogICAgICAgJGV4dHJhaW5mbyAuPSAnICcuJHRleHRzcGVlZCBpZiAkdGV4dHNwZWVkOwogICAgIH0gZWxzaWYgKGRlZmluZWQgKCRzcGVlZCA9ICRzbm1waW5mby0+eyRpZn0tPntp\
ZlNwZWVkfSkgYW5kICRzcGVlZCkgewogICAgICAgICAjIFNwZWVkIGluIGJpdHMgcHIuIHNlY29uZAotCSR3YXJuID0gJHNwZWVkLzEwMCo3NTsKKwkkd2FybiA9ICRzcGVlZC8xMDAqNjA7CisJJGNyaXQgPSAkc3BlZWQvMTAwKjgwOwogCiAJbXkgJHRleHRzcGVlZCA9IHNjYWxlTnVtYmVyKCRzcGVlZCwnYnBzJywnJywKIAkJCQkgICAgJ1RoZSBpbnRlcmZhY2Ugc3BlZWQgaXMgJS4xZiVzJXMuJyk7CkBAIC02NjYsMTcgKzY2OSwyMCBAQCBzdWIgZG9fY29uZmlnX2lmIHsKICAgICBwcmludCAicmVjdi5jZGVmIHJlY3YsOCwqXG4iOwogICAgIHByaW50ICJyZWN2Lm1heCAkc3BlZWRcbiIgaWYgJHNwZWVkOwogICAgIHByaW50ICJyZWN2Lm1pbiAwXG4iOwot\
ICAgIHByaW50ICJyZWN2Lndhcm5pbmcgJHdhcm5cbiIgaWYgZGVmaW5lZCAkd2FybjsKKyAgICBwcmludF90aHJlc2hvbGRzKCJyZWN2Iix1bmRlZix1bmRlZiwkd2FybiwkY3JpdCkgaWYgZGVmaW5lZCAkd2FybiAmJiBkZWZpbmVkICRjcml0OwogICAgIHByaW50ICJzZW5kLmxhYmVsIGJwc1xuIjsKICAgICBwcmludCAic2VuZC50eXBlIERFUklWRVxuIjsKICAgICBwcmludCAic2VuZC5uZWdhdGl2ZSByZWN2XG4iOwogICAgIHByaW50ICJzZW5kLmNkZWYgc2VuZCw4LCpcbiI7CiAgICAgcHJpbnQgInNlbmQubWF4ICRzcGVlZFxuIiBpZiAkc3BlZWQ7CiAgICAgcHJpbnQgInNlbmQubWluIDBcbiI7Ci0gICAgcHJpbnQgInNlbmQud2FybmluZyAkd2Fyblxu\
IiBpZiBkZWZpbmVkICR3YXJuOworICAgIHByaW50X3RocmVzaG9sZHMoInNlbmQiLHVuZGVmLHVuZGVmLCR3YXJuLCRjcml0KSBpZiBkZWZpbmVkICR3YXJuICYmIGRlZmluZWQgJGNyaXQ7CiAKICAgICBwcmludCAibXVsdGlncmFwaCBpZl9lcnJvcnMuaWZfJGlmXG4iOwogCisgICAgJHdhcm49MTsKKyAgICAkY3JpdD0xMDA7CisKICAgICBwcmludCAiZ3JhcGhfdGl0bGUgSW50ZXJmYWNlICRhbGlhcyBlcnJvcnNcbiI7CiAgICAgcHJpbnQgImdyYXBoX29yZGVyIHJlY3Ygc2VuZFxuIjsKICAgICBwcmludCAiZ3JhcGhfYXJncyAtLWJhc2UgMTAwMFxuIjsKQEAgLTY4OSwxMiArNjk1LDEyIEBAIHN1YiBkb19jb25maWdfaWYgewogICAgIHByaW50ICJyZWN2\
LnR5cGUgREVSSVZFXG4iOwogICAgIHByaW50ICJyZWN2LmdyYXBoIG5vXG4iOwogICAgIHByaW50ICJyZWN2Lm1pbiAwXG4iOwotICAgIHByaW50ICJyZWN2Lndhcm5pbmcgMVxuIjsKKyAgICBwcmludF90aHJlc2hvbGRzKCJyZWN2Iix1bmRlZix1bmRlZiwkd2FybiwkY3JpdCkgaWYgZGVmaW5lZCAkd2FybiAmJiBkZWZpbmVkICRjcml0OwogICAgIHByaW50ICJzZW5kLmxhYmVsIGVycm9yc1xuIjsKICAgICBwcmludCAic2VuZC50eXBlIERFUklWRVxuIjsKICAgICBwcmludCAic2VuZC5uZWdhdGl2ZSByZWN2XG4iOwogICAgIHByaW50ICJzZW5kLm1pbiAwXG4iOwotICAgIHByaW50ICJzZW5kLndhcm5pbmcgMVxuIjsKKyAgICBwcmludF90aHJlc2hvbGRz\
KCJzZW5kIix1bmRlZix1bmRlZiwkd2FybiwkY3JpdCkgaWYgZGVmaW5lZCAkd2FybiAmJiBkZWZpbmVkICRjcml0OwogfQogCiAK' | base64 -d | patch -p0 \
 && chmod a+x * \
 && chmod a-x plugins* \
# && mkdir /run/nginx \
 && true

COPY rootfs/ /

# Expose volumes
#VOLUME /etc/munin/munin-conf.d /etc/munin/plugin-conf.d /var/lib/munin /var/log/munin

# Expose nginx
EXPOSE 80

# Use dumb-init since we run a lot of processes
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Run start script or what you choose
CMD /docker-cmd.sh

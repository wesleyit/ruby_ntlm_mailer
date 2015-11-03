# encoding: utf-8
require 'ntlm/smtp'
require 'yaml'

## Reads the file config.yml to parse the config values.
# An exception is thrown if the file is not found.
@config_file = './config.yml'
unless File.exists? @config_file
	raise "Config file not found. Please, create a valid #{@config_file}."
end
@config = YAML.load_file(@config_file)

## Read a file named "message.html" on the current folder
# and set as message body
@body_file = './message.html'
unless File.exists? @body_file
	raise "Message file not found. Please, create a valid #{@body_file}."
end
@body = File.read(@body_file)

## The structure of your e-mail is assembled here
@message = <<MESSAGE_END
From: #{@config['from_name']} <#{@config['from_addr']}>
To: #{@config['to_name']} <#{@config['to_addr']}>
MIME-Version: 1.0
Content-type: text/html
Subject: #{@config['subject']}
#{@body}
MESSAGE_END

## Create a new authentication session with NTLM and send
# the message using MS-Exchange
@smtp = Net::SMTP.new(@config['smtp_server'])
@smtp.start(@config['localhost'], "#{@config['login_domain']}\\#{@config['login_user']}", @config['login_password'], :ntlm) do |smtp|
	smtp.send_mail(@message, @config['from_addr'], @config['to_addr'])
end

# Be sure to restart your server when you modify this file.

module ActiveRecord
	class Base
		def self.mysql2_connection(config)
			config[:username] = 'root' if config[:username].nil?
			if Mysql2::Client.const_defined? :FOUND_ROWS
				config[:flags] = config[:flags] ? config[:flags] | Mysql2::Client::FOUND_ROWS : Mysql2::Client::FOUND_ROWS
			end
			client = Mysql2::Client.new(config.symbolize_keys)
			options = [config[:host], config[:username], config[:password], config[:database], config[:port], config[:socket], 0]
			ConnectionAdapters::Mysql2Adapter.new(client, logger, options, config)
		end
	end
end 
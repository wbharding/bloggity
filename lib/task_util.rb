# Here's a location to keep task-specific defines
module TaskUtil
	
	# ---------------------------------------------------------------------------
	# 
	def setup_logger(options = {})
		log_name = options[:log_name] || "raketasks"
		logger = Logger.new("#{RAILS_ROOT}/log/#{log_name}.log")
		logger.info("Logger started at #{Time.now.strftime('%c')}")
		logger
	end
	
	# ---------------------------------------------------------------------------
	# Ensures that CTRL-C / kill will stop tasks, even if the task is inside a begin/rescue block
	def setup_traps
	end
	
	# ---------------------------------------------------------------------------
	# Ensures that CTRL-C / kill will stop tasks, even if the task is inside a begin/rescue block
	def setup_traps
		Signal.trap("TERM") { yield }
		Signal.trap("INT") { yield }
	end
end

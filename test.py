import logging

# 配置日志记录器，设置日志级别和日志格式
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    handlers=[
                        logging.FileHandler("your_log_file.log"),  # 文件日志
                        logging.StreamHandler()  # 控制台日志
                    ])

# 测试日志输出
logging.debug('这是一个debug信息')
logging.info('这是一个info信息')
logging.warning('这是一个warning信息')
logging.error('这是一个error信息')
logging.critical('这是一个critical信息')

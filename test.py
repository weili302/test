import re
import re

def filter_names(names, full_name):
    # 将全名拆分为两个部分
    name1, name2 = full_name.split()
    # 构建正则表达式模式
    pattern = re.compile(rf'\b({name1}-\w+[,]? {name2}|{name2}-\w+[,]? {name1}|{name1}[,]? {name2}|{name2}[,]? {name1}|{name1}[,]? {name2}-\w+|{name2}[,]? {name1}-\w+)\b', re.IGNORECASE)
    filtered_names = [name for name in names if pattern.search(name)]
    return filtered_names

if __name__ == "__main__":
    names = [
        "a b", "b a", "a-xxx b", "b-xxx a", "a, b", "b, a", "c d", "d c", "a-sd b", "b-edg, a","eca b", "bdf, a"
    ]
    full_name = "a b"
    filtered_names = filter_names(names, full_name)
    print(filtered_names)

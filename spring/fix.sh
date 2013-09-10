# 解决乱码
# export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

# Chinese Tokenizer
mvn install:install-file -Dfile=./lib/IKAnalyzer2012.jar -DgroupId=org.wltea.ik-analyzer  -DartifactId=ik-analyzer -Dversion=4.0.0 -Dpackaging=jar
# Natural Language Analyzer
mvn install:install-file -Dfile=./lib/lingpipe-4.1.0.jar -DgroupId=com.lingpipe -DartifactId=lingpipe -Dversion=4.1.0 -Dpackaging=jar  

mvn dependency:list
mvn eclipse:eclipse

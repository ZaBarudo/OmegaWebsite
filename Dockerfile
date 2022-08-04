FROM ubuntu


RUN apt-get update
RUN apt-get -y install acl
RUN apt-get -y install datamash
RUN apt-get -y install python3-pip
RUN apt-get -y install curl
RUN pip3 install markupsafe==2.0.1
RUN pip3 install Flask==1.1.4
RUN pip3 install mysql.connector
RUN echo 'root:Docker' | chpasswd
COPY main/app.py /app/app.py
COPY main/db.py /app/db.py
COPY main/templates /app/templates
COPY main/files /app/files
COPY main/genUser.sh /app/genUser.sh
COPY main/aliasGen.sh /app/aliasGen.sh
COPY main/allotInterest.sh /app/allotInterest.sh
COPY main/genSummary.sh /app/genSummary.sh
COPY main/makeTransaction.sh /app/makeTransaction.sh
COPY main/permit.sh /app/permit.sh
COPY main/updateBranch.sh /app/updateBranch.sh
WORKDIR /app
RUN ./genUser.sh
RUN ./aliasGen.sh
RUN echo "ACC0001 +100 2022-02-01 19:26:12" >> /app/OmegaBank/Branch2/ACC0001/Transaction_History.txt

CMD bash -c "./permit.sh ; python3 app.py"
EXPOSE 5000



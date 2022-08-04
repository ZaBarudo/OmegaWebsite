from flask import Flask,render_template,request,session,redirect,url_for
import os, sys, time
import mysql.connector

usrs = ['ACC'+f'{i:04}' for i in range(1,51)]
branches = dict()

config = {
        'user': 'root',
        'password': 'root',
        'host': 'db',
        'port': '3306',
        'database': 'omegabank'
    }
while True:
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor(buffered=True)
        if connection.is_connected():
            break
    except:
        time.sleep(0.5)


for folder in os.listdir('/app/OmegaBank'):
    if folder != 'CEO':
        temp=[]
        for user in os.listdir(f"/app/OmegaBank/{folder}"):
            if user.startswith('ACC'):
                temp.append(user)
        branches[folder.capitalize()+'MGR'] = temp
                


app = Flask(__name__)
app.secret_key = os.urandom(24)






@app.route('/', methods=['GET', 'POST'])
def index():
 
    if 'user' in session:
        if session['user'] in branches:
            return redirect(url_for('branch_mgr'))
        elif session['user'] in usrs:
            return redirect(url_for('user'))



    if request.method == 'POST':
        session.pop('user', None)

        username = request.form['username']
        passwd = request.form['password']

        if passwd == 'root':
            
            if username in branches:
                session['user'] = username
                return redirect(url_for('branch_mgr'))
            if username in usrs:
                session['user'] = username
                return redirect(url_for('user'))
        return redirect(url_for('index'))
        
    return render_template('index.html')
                
            


@app.route('/manager')
def branch_mgr():
    if 'user' in session:
        mgr = session['user']
        if mgr in branches:
            transactions = []
            for temp in branches[mgr]:
                cursor.execute(f'SELECT * FROM {temp.lower()}')
                transactions.extend([[temp]+[*x] for x in cursor])
            return render_template('mgr.html', transactions=transactions)
    return redirect(url_for('index'))



@app.route('/user')
def user():
    if 'user' in session:
        usr = session['user']
        if usr in usrs:
            cursor.execute(f'SELECT * FROM {usr.lower()}')
            transactions = [[*x] for x in cursor]
        
            return render_template('usr.html', transactions=transactions)
    return redirect(url_for('index'))


@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0',port='5000',debug=True)

cursor.close()
connection.close()
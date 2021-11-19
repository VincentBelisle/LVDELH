import sys
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
import mysql.connector


mydb = mysql.connector.connect(
    host="localhost",
    user="hero",    
    password="hero",
    database="ldvelh")


class Livre(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Livre")
        self.setFixedSize(QSize(1900, 1000))
        self.text = QTextEdit()

        self.division = QLabel("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
        self.bouttonrecherche = QPushButton("Aller au chapitre")
        self.recherche = QLineEdit()

        self.sac = QLineEdit()

        layoutgauche = QVBoxLayout()
        layoutdroit = QVBoxLayout()
        layoutHori = QHBoxLayout()

        layoutgauche.addWidget(self.text)
        layoutgauche.addWidget(self.division)
        layoutgauche.addWidget(self.recherche)
        layoutgauche.addWidget(self.bouttonrecherche)

        layoutdroit.addWidget(self.sac)


        layoutHori.addLayout(layoutgauche)
        layoutHori.addLayout(layoutdroit)

        container = QWidget()
        container.setLayout(layoutHori)
        self.setCentralWidget(container)


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.Livre = Livre()
        self.setWindowTitle("Login")
        self.setFixedSize(QSize(400, 200))
        button = QPushButton("Connection")
        button.clicked.connect(self.Clicked)
        button.setCheckable(True)
        self.labellogin = QLabel('Login :')
        self.login = QLineEdit()
        self.labelpassword = QLabel('Password :')
        self.password = QLineEdit()
        


        layout = QVBoxLayout()
        layout.addWidget(self.labellogin)
        layout.addWidget(self.login)
        layout.addWidget(self.labelpassword)
        layout.addWidget(self.password)
        layout.addWidget(button)

        

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)


    def Clicked(self, checked):
        if self.login.text() == "hero" and self.password.text() == "hero":
            if self.isVisible():
                self.hide()
                self.Livre.show()
        else:
            self.login.setText("")
            self.password.setText("")




app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()
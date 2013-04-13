import sys, signal

from PyQt4.QtCore import QTimer, QObject, QUrl
from PyQt4.QtGui import QApplication
from PyQt4.QtDeclarative import QDeclarativeView

def sigint_handler(*args):
  QApplication.quit()

signal.signal(signal.SIGINT, sigint_handler)

app = QApplication(sys.argv)

# Create the QML user interface.
view = QDeclarativeView()
view.setSource(QUrl('mazakodron.qml'))
view.setResizeMode(QDeclarativeView.SizeRootObjectToView)

rootObject = view.rootObject()

rootObject.dropMazak()

view.setGeometry(0, 0, 800, 600)
view.show()

timer = QTimer()
timer.start(100)
timer.timeout.connect(lambda: None)

sys.exit(app.exec_())

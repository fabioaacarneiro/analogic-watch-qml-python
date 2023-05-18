"""arquivo principal do python para manipular qml"""
import sys

from time import strftime, localtime

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QTimer, QObject, Signal


app = QGuiApplication(sys.argv)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.load('./ui/main.qml')


class Backend(QObject):
    """classe que constrói o objeto backend"""
    updated = Signal(str, arguments=['time'])
    hms = Signal(int, int, int, arguments=['hours', 'minutes', 'seconds'])

    def __init__(self):
        super().__init__()

        self.timer = QTimer()
        self.timer.setInterval(100)
        self.timer.timeout.connect(self.update_time)
        self.timer.start()

    def update_time(self):
        """método para atualizar o tempo no qml"""
        local_time = localtime()
        curr_time = strftime("%H:%M:%S", local_time)
        self.updated.emit(curr_time)
        self.hms.emit(
            local_time.tm_hour,
            local_time.tm_min,
            local_time.tm_sec
        )


backend = Backend()
engine.rootObjects()[0].setProperty('backend', backend)

backend.update_time()
sys.exit(app.exec())

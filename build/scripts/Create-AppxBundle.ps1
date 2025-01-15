import pyttsx3
import speech_recognition as sr
import cv2
import numpy as np
import pyautogui
import os

# Configuração do sintetizador de voz
engine = pyttsx3.init()
engine.setProperty('rate', 150)  # Velocidade da fala
engine.setProperty('voice', 'com.microsoft.david')  # Ajustar para o timbre desejado

def speak(text):
    engine.say(text)
    engine.runAndWait()

# Reconhecimento de fala
def listen():
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        speak("Estou ouvindo...")
        try:
            audio = recognizer.listen(source, timeout=5)
            command = recognizer.recognize_google(audio, language="pt-BR")
            return command.lower()
        except sr.UnknownValueError:
            speak("Desculpe, não entendi.")
        except sr.WaitTimeoutError:
            speak("Você não disse nada.")
        return None

# Captura da câmera
def recognize_face():
    speak("Acessando a câmera para reconhecimento facial.")
    cap = cv2.VideoCapture(0)
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")

    while True:
        ret, frame = cap.read()
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

        if len(faces) > 0:
            speak("Rosto identificado. Bem-vindo.")
            cap.release()
            cv2.destroyAllWindows()
            return True

        cv2.imshow('Reconhecimento Facial', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
    return False

# Controle do sistema
def control_system(command):
    if "abrir navegador" in command:
        os.system("start chrome")
        speak("Abrindo o navegador.")
    elif "capturar tela" in command:
        screenshot = pyautogui.screenshot()
        screenshot.save("screenshot.png")
        speak("Tela capturada e salva.")
    elif "encerrar" in command:
        speak("Encerrando sistema. Até logo.")
        exit()
    else:
        speak("Comando não reconhecido.")

# Loop principal da IA
def main():
    speak("Olá, sou seu assistente pessoal.")
    authenticated = recognize_face()
    if not authenticated:
        speak("Acesso negado. Encerrando.")
        return

    while True:
        command = listen()
        if command:
            control_system(command)

if __name__ == "__main__":
    main()


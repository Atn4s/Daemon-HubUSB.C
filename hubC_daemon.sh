#!/bin/bash
# 
LOGFILE="/var/log/hubC_daemon.log" # local para armazenar os logs
TECLADO="258a:1006"  # ID do teclado, obtido através do lsusb
MOUSE="046d:c084"    # ID do mouse, obtido através do lsusb

echo "Iniciando daemon de monitoramento do Hub USB-C..." | tee -a $LOGFILE

# Descobre automaticamente o endereço do controlador USB
USB_CONTROLLER=$(lspci | grep -i usb | grep -i 'xHCI' | awk '{print $1}')

reload_usb() {
    if [ -n "$USB_CONTROLLER" ]; then
        echo "$(date) - Reiniciando controlador USB ($USB_CONTROLLER)..." | tee -a $LOGFILE
        echo "$USB_CONTROLLER" | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
        sleep 1
        echo "$USB_CONTROLLER" | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind
    else
        echo "$(date) - Erro: Controlador USB não encontrado!" | tee -a $LOGFILE
    fi
}

while true; do
    if ! lsusb | grep -q "$TECLADO" && ! lsusb | grep -q "$MOUSE"; then
        echo "$(date) - Teclado e mouse sumiram! Esperando antes de agir..." | tee -a $LOGFILE
        sleep 3  # Espera para evitar reinicializações desnecessárias

        # Faz uma nova verificação para garantir que ainda estão ausentes
        if ! lsusb | grep -q "$TECLADO" && ! lsusb | grep -q "$MOUSE"; then
            echo "$(date) - Confirmado! Reiniciando USB..." | tee -a $LOGFILE
            reload_usb
            sleep 5 # Espera 5 segundos antes de verificar de novo
        else
            echo "$(date) - Dispositivos voltaram sozinhos, não precisa reiniciar." | tee -a $LOGFILE
        fi
    fi
    sleep 2 # Verifica a cada 2 segundos
done

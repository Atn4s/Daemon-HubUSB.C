# Daemon para Reinicialização Automática de Hubs USB-C

Este repositório foi criado para resolver um problema que identifiquei ao utilizar um hub USB-C conectado ao meu teclado e mouse. Sempre que o hub era desconectado e reconectado com o sistema rodando, os dispositivos não eram reconhecidos novamente, tornando-os inutilizáveis até um reinício do sistema.

O modelo de hub é semelhante a este:
![imagem de um hub usb c com 4 portas usbs](https://chipsetinfo.com.br/imgcache/2348/1000x/uploads/2348/product/photo_6229089d71941.jpg.webp) 

# 💡 Inspiração e Solução

A solução inicial foi encontrada graças às discussões no StackExchange e Reddit (obrigado SlightResult!): <br> 
🔗 StackExchange: <a href=https://unix.stackexchange.com/questions/598094/usb-c-port-becomes-unusable-after-unplugging-until-reboot>usb c port becomes unusable after unplugging until reboot</a> <br> 
🔗 Reddit: <a href=https://www.reddit.com/r/linuxquestions/comments/htwo8n/usb_c_port_becomes_unusable_after_unplugging>usb c port becomes unusable after unplugging until reboot</a> <br>

Com base nisso, surgiu a ideia: seria possível automatizar a detecção do hub e reiniciá-lo automaticamente quando desconectado?

A resposta foi sim! 💡 E com a ajuda do ChatGPT, desenvolvi este daemon em Shell Script que monitora o hub e reinicializa o controlador USB quando necessário.

# ⚙️ Como Funciona?

Este daemon monitora continuamente os IDs do teclado e mouse conectados ao hub. Caso ambos desapareçam do sistema, ele executa um reset no controlador USB automaticamente, garantindo que os dispositivos voltem a funcionar sem precisar reiniciar o computador.

Isso pode ser útil, por exemplo, para manutenção do teclado (especialmente teclados mecânicos, onde é comum realizar limpezas nos switches).

# 📌 Requisitos e Configuração

1️⃣ O script é feito em Shell Script e precisa ser executado como root para ter permissão para reinicializar o controlador USB. <br>
2️⃣ Antes de rodar, é necessário modificar as variáveis TECLADO e MOUSE no script para corresponder aos IDs dos seus dispositivos (esses IDs podem ser obtidos via lsusb). <br>
3️⃣ O código possui um sistema de delay (sleep) para garantir que os dispositivos tenham tempo suficiente para serem desligados e religados corretamente. <br>

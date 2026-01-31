#-
--------------------------------------------------------------------
| Mitsubishi Electric HVAC sensors display driver written in Berry |
|   #1 coded by aldweb (December 17th, 2024)                       |
|   #2 enhanced with control buttons (January 30th, 2026)          |
--------------------------------------------------------------------

aldweb version #1
- for those using the MiElHVAC driver (https://github.com/arendst/Tasmota/blob/development/tasmota/tasmota_xdrv_driver/xdrv_44_miel_hvac.ino),
  this berry display driver lets you visualize the MiElHVAC sensor parameters on the Tasmota web console, which it does not offer by default.
- if not all parameters are required in your setting, then just quote the required lines (2 of them for each parameter, the one starting 
  with "{s}MiElHVAC and the corresponding one starting with sensors['MiElHVAC']).

aldweb version #2  
- added interactive buttons to control Mode, Set Temperature, Fan Speed, Swing Vertical and Swing Horizontal.

-#

var sensors

class HVAC : Driver

  #- read sensor data -#
  def read_hvac()
    import json
    sensors=json.load(tasmota.read_sensors())
  end

  #- trigger a read every second -#
  def every_second()
    self.read_hvac()
  end

  #- display sensor value in the web UI -#
  def web_sensor()
    import string
    import webserver
    
    # Handle button clicks first
    # Check for mode changes
    if webserver.has_arg("m_miel_mode")
      var mode = webserver.arg("m_miel_mode")
      tasmota.cmd(string.format("HVACSetMode %s", mode))
    end
    
    # Check for temperature changes
    if webserver.has_arg("m_miel_temp")
      var temp_delta = real(webserver.arg("m_miel_temp"))
      var current_temp = real(sensors['MiElHVAC']['SetTemperature'])
      var new_temp = current_temp + temp_delta
      # Clamp between 10 and 31
      if new_temp < 10 new_temp = 10 end
      if new_temp > 31 new_temp = 31 end
      tasmota.cmd(string.format("HVACSetTemp %.1f", new_temp))
    end
    
    # Check for fan speed changes
    if webserver.has_arg("m_miel_fan")
      var fan = webserver.arg("m_miel_fan")
      tasmota.cmd(string.format("HVACSetFanSpeed %s", fan))
    end
    
    # Check for swing V changes
    if webserver.has_arg("m_miel_swingv")
      var swingv = webserver.arg("m_miel_swingv")
      tasmota.cmd(string.format("HVACSetSwingV %s", swingv))
    end
    
    # Check for swing H changes
    if webserver.has_arg("m_miel_swingh")
      var swingh = webserver.arg("m_miel_swingh")
      tasmota.cmd(string.format("HVACSetSwingH %s", swingh))
    end
    
    # Display sensor values
    # Calculate OperationTime in days, hours, minutes
    var total_minutes = int(sensors['MiElHVAC']['OperationTime'])
    var days = int(total_minutes / 1440)
    var remaining_minutes = int(total_minutes % 1440)
    var hours = int(remaining_minutes / 60)
    var minutes = int(remaining_minutes % 60)
    var operation_time_str = ""
    if days >= 1
      # Afficher jours et heures seulement
      operation_time_str = string.format("%dd %dhr", days, hours)
    else
      # Afficher heures et minutes seulement
      operation_time_str = string.format("%dhr %dmn", hours, minutes)
    end
    
    var msg = string.format(
      "{s}MiElHVAC Power{m}%s{e}"
      "{s}MiElHVAC Mode{m}%s{e}"
      "{s}MiElHVAC SetTemperature{m}%1.1f °%s{e}"
      "{s}MiElHVAC FanSpeed{m}%i{e}"
      "{s}MiElHVAC SwingV{m}%s{e}"
      "{s}MiElHVAC SwingH{m}%s{e}"
#      "{s}MiElHVAC AirDirection{m}%s{e}"
#      "{s}MiElHVAC Prohibit{m}%s{e}"
      "{s}MiElHVAC RoomTemperature{m}%1.1f °%s{e}"
#      "{s}MiElHVAC RemoteTemperatureSensorState{m}%s{e}"
#      "{s}MiElHVAC RemoteTemperatureSensorAutoClearTime{m}%i{e}"
      "{s}MiElHVAC OutdoorTemperature{m}%1.1f °%s{e}"
      "{s}MiElHVAC OperationTime{m}%s{e}"
#      "{s}MiElHVAC TimerMode{m}%s{e}"
#      "{s}MiElHVAC TimerOn{m}%i{e}"
#      "{s}MiElHVAC TimerOnRemaining{m}%i{e}"
#      "{s}MiElHVAC TimerOff{m}%i{e}"
#      "{s}MiElHVAC TimerOffRemaining{m}%i{e}"
      "{s}MiElHVAC Compressor{m}%s{e}"
#      "{s}MiElHVAC CompressorFrequency{m}%i{e}"
      "{s}MiElHVAC OperationPower{m}%i kW{e}"
      "{s}MiElHVAC OperationEnergy{m}%1.1f kWh{e}",
#      "{s}MiElHVAC OperationStage{m}%s{e}"
#      "{s}MiElHVAC FanStage{m}%i{e}"
#      "{s}MiElHVAC ModeStage{m}%s{e}"
      sensors['MiElHVAC']['Power'],
      sensors['MiElHVAC']['Mode'],
      sensors['MiElHVAC']['SetTemperature'], sensors['TempUnit'],
      sensors['MiElHVAC']['FanSpeed'],
      sensors['MiElHVAC']['SwingV'],
      sensors['MiElHVAC']['SwingH'],
#      sensors['MiElHVAC']['AirDirection'],
#      sensors['MiElHVAC']['Prohibit'],
      sensors['MiElHVAC']['Temperature'], sensors['TempUnit'],
#      sensors['MiElHVAC']['RemoteTemperatureSensorState'],
#      sensors['MiElHVAC']['RemoteTemperatureSensorAutoClearTime'],
      sensors['MiElHVAC']['OutdoorTemperature'], sensors['TempUnit'],
      operation_time_str,
#      sensors['MiElHVAC']['TimerMode'],
#      sensors['MiElHVAC']['TimerOn'],
#      sensors['MiElHVAC']['TimerOnRemaining'],
#      sensors['MiElHVAC']['TimerOff'],
#      sensors['MiElHVAC']['TimerOffRemaining'],
      sensors['MiElHVAC']['Compressor'],
#      sensors['MiElHVAC']['CompressorFrequency'],
      sensors['MiElHVAC']['OperationPower'],
      sensors['MiElHVAC']['OperationEnergy']
#      sensors['MiElHVAC']['OperationStage'],
#      sensors['MiElHVAC']['FanStage'],
#      sensors['MiElHVAC']['ModeStage']
    )
    tasmota.web_send_decimal(msg)
  end

  #- add control buttons to web interface -#
  def web_add_main_button()
    import webserver
    import string
    
    # Add custom CSS for better button styling
    webserver.content_send("<style>")
    webserver.content_send(".hvac-control{margin:5px 0;padding:5px 10px;background:#1fa3ec;border-radius:5px;}")
    webserver.content_send(".hvac-control.compact{padding:3px 10px;}")
    webserver.content_send(".hvac-title{color:#fff;font-weight:bold;margin-bottom:0;font-size:1em;flex:0 0 48%;}")
    webserver.content_send(".hvac-inline{display:flex;align-items:center;gap:5px;}")
    webserver.content_send(".hvac-btn{margin:0;border:none;border-radius:3px;cursor:pointer;background:#fff;color:#1fa3ec;font-size:1em;flex:0 0 48%;}")
    webserver.content_send("select.hvac-btn{padding:5px 10px;}")
    webserver.content_send("button.hvac-btn{padding:3px;font-size:0.9em;}")
    webserver.content_send(".hvac-btn:hover{background:#e0e0e0;}")
    webserver.content_send(".hvac-btn:active{background:#c0c0c0;}")
    webserver.content_send(".hvac-toggle-btn{width:100%;padding:10px;margin:10px 0;background:#1fa3ec;color:#fff;border:none;border-radius:5px;cursor:pointer;font-weight:bold;font-size:1em;}")
    webserver.content_send(".hvac-toggle-btn:hover{background:#1890d0;}")
    webserver.content_send(".hvac-controls-container{display:none;}")
    webserver.content_send(".hvac-controls-container.show{display:block;}")
    webserver.content_send(".hvac-temp-btns{display:flex;gap:3px;flex:0 0 48%;align-items:center;}")
    webserver.content_send(".hvac-temp-btns button{flex:1;}")
    webserver.content_send("</style>")
    webserver.content_send("<script>")
    webserver.content_send("function toggleHVACControls(){")
    webserver.content_send("var container=document.getElementById('hvac-controls');")
    webserver.content_send("var btn=document.getElementById('hvac-toggle');")
    webserver.content_send("container.classList.toggle('show');")
    webserver.content_send("if(container.classList.contains('show')){")
    webserver.content_send("btn.innerHTML='HVAC Control&nbsp;&nbsp;&nbsp;&#9650;';")
    webserver.content_send("}else{")
    webserver.content_send("btn.innerHTML='HVAC Control&nbsp;&nbsp;&nbsp;&#9660;';")
    webserver.content_send("}")
    webserver.content_send("}")
    webserver.content_send("</script>")
    
    # Toggle button
    webserver.content_send("<button id='hvac-toggle' class='hvac-toggle-btn' onclick='toggleHVACControls();'>HVAC Control&nbsp;&nbsp;&nbsp;&#9660;</button>")
    
    # Container for all controls
    webserver.content_send("<div id='hvac-controls' class='hvac-controls-container'>")
    
    # Temperature Control
    webserver.content_send("<div class='hvac-control compact'>")
    webserver.content_send("<div class='hvac-inline'>")
    webserver.content_send("<div class='hvac-title'>Set Temperature</div>")
    webserver.content_send("<div class='hvac-temp-btns'>")
    webserver.content_send(string.format("<button class='hvac-btn' onclick='la(\"&m_miel_temp=-1\");'>-1°%s</button>", sensors['TempUnit']))
    webserver.content_send(string.format("<button class='hvac-btn' onclick='la(\"&m_miel_temp=0.5\");'>+&#189;°%s</button>", sensors['TempUnit']))
    webserver.content_send(string.format("<button class='hvac-btn' onclick='la(\"&m_miel_temp=1\");'>+1°%s</button>", sensors['TempUnit']))
    webserver.content_send("</div>")
    webserver.content_send("</div>")
    webserver.content_send("</div>")
    
    # Fan Speed Control
    webserver.content_send("<div class='hvac-control'>")
    webserver.content_send("<div class='hvac-inline'>")
    webserver.content_send("<div class='hvac-title'>Fan Speed</div>")
    var current_fan = str(sensors['MiElHVAC']['FanSpeed'])
    webserver.content_send("<select class='hvac-btn' onchange='la(\"&m_miel_fan=\"+this.value);'>")
    webserver.content_send("<option value=''>Select Speed...</option>")
    webserver.content_send(string.format("<option value='auto'%s>Auto</option>", current_fan == 'auto' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='quiet'%s>Quiet</option>", current_fan == 'quiet' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='1'%s>Speed 1</option>", current_fan == '1' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='2'%s>Speed 2</option>", current_fan == '2' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='3'%s>Speed 3</option>", current_fan == '3' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='4'%s>Speed 4</option>", current_fan == '4' ? ' selected' : ''))
    webserver.content_send("</select>")
    webserver.content_send("</div>")
    webserver.content_send("</div>")
    
    # Swing Vertical Control
    webserver.content_send("<div class='hvac-control'>")
    webserver.content_send("<div class='hvac-inline'>")
    webserver.content_send("<div class='hvac-title'>Swing Vertical</div>")
    var current_swingv = sensors['MiElHVAC']['SwingV']
    webserver.content_send("<select class='hvac-btn' onchange='la(\"&m_miel_swingv=\"+this.value);'>")
    webserver.content_send("<option value=''>Select Position...</option>")
    webserver.content_send(string.format("<option value='auto'%s>Auto</option>", current_swingv == 'auto' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='up'%s>Up</option>", current_swingv == 'up' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='up_middle'%s>Up Middle</option>", current_swingv == 'up_middle' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='center'%s>Center</option>", current_swingv == 'center' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='down_middle'%s>Down Middle</option>", current_swingv == 'down_middle' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='down'%s>Down</option>", current_swingv == 'down' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='swing'%s>Swing</option>", current_swingv == 'swing' ? ' selected' : ''))
    webserver.content_send("</select>")
    webserver.content_send("</div>")
    webserver.content_send("</div>")
    
    # Swing Horizontal Control
    webserver.content_send("<div class='hvac-control'>")
    webserver.content_send("<div class='hvac-inline'>")
    webserver.content_send("<div class='hvac-title'>Swing Horizontal</div>")
    var current_swingh = sensors['MiElHVAC']['SwingH']
    webserver.content_send("<select class='hvac-btn' onchange='la(\"&m_miel_swingh=\"+this.value);'>")
    webserver.content_send("<option value=''>Select Position...</option>")
    webserver.content_send(string.format("<option value='auto'%s>Auto</option>", current_swingh == 'auto' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='left'%s>Left</option>", current_swingh == 'left' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='left_middle'%s>Left Middle</option>", current_swingh == 'left_middle' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='center'%s>Center</option>", current_swingh == 'center' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='right'%s>Right</option>", current_swingh == 'right' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='right_middle'%s>Right Middle</option>", current_swingh == 'right_middle' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='split'%s>Split</option>", current_swingh == 'split' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='swing'%s>Swing</option>", current_swingh == 'swing' ? ' selected' : ''))
    webserver.content_send("</select>")
    webserver.content_send("</div>")
    webserver.content_send("</div>")
    
    # Mode Control (moved to bottom)
    webserver.content_send("<div class='hvac-control'>")
    webserver.content_send("<div class='hvac-inline'>")
    webserver.content_send("<div class='hvac-title'>Mode</div>")
    var current_mode = sensors['MiElHVAC']['Mode']
    webserver.content_send("<select class='hvac-btn' onchange='la(\"&m_miel_mode=\"+this.value);'>")
    webserver.content_send("<option value=''>Select Mode...</option>")
    webserver.content_send(string.format("<option value='heat'%s>Heat</option>", current_mode == 'heat' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='cool'%s>Cool</option>", current_mode == 'cool' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='dry'%s>Dry</option>", current_mode == 'dry' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='fan'%s>Fan</option>", current_mode == 'fan' ? ' selected' : ''))
    webserver.content_send(string.format("<option value='auto'%s>Auto</option>", current_mode == 'auto' ? ' selected' : ''))
    webserver.content_send("</select>")
    webserver.content_send("</div>")
    webserver.content_send("</div>")
    
    # Close controls container
    webserver.content_send("</div>")
  end

end

HVAC = HVAC()
tasmota.add_driver(HVAC)

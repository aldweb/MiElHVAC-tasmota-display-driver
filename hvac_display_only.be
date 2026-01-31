#-
--------------------------------------------------------------------
| Mitsubishi Electric HVAC sensors display driver written in Berry |
|   #1 coded by aldweb (December 17th, 2024)                       |
--------------------------------------------------------------------

aldweb version #1
- for those using the MiElHVAC driver (https://github.com/arendst/Tasmota/blob/development/tasmota/tasmota_xdrv_driver/xdrv_44_miel_hvac.ino),
  this berry display driver lets you visualize the MiElHVAC sensor parameters on the Tasmota web console, which it does not offer by default.
- if not all parameters are required in your setting, then just quote the required lines (2 of them for each parameter, the one starting 
  with "{s}MiElHVAC  and the one starting with sensors['MiElHVAC']).
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

end

HVAC = HVAC()
tasmota.add_driver(HVAC)

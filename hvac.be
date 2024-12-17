#-
--------------------------------------------------------------------
| Mitsubishi Electric HVAC sensors display driver written in Berry |
|   coded by aldweb (December 17th, 2024)                          |
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
    var msg = string.format(
      "{s}MiElHVAC Power{m}%s{e}"
      "{s}MiElHVAC Mode{m}%s{e}"
      "{s}MiElHVAC SetTemperature{m}%1.1f °%s{e}"
      "{s}MiElHVAC FanSpeed{m}%i{e}"
      "{s}MiElHVAC SwingV{m}%s{e}"
      "{s}MiElHVAC SwingH{m}%s{e}"
      "{s}MiElHVAC AirDirection{m}%s{e}"
      "{s}MiElHVAC Prohibit{m}%s{e}"
      "{s}MiElHVAC RoomTemperature{m}%1.1f °%s{e}"
      "{s}MiElHVAC RemoteTemperatureSensorState{m}%s{e}"
      "{s}MiElHVAC RemoteTemperatureSensorAutoClearTime{m}%i{e}"
      "{s}MiElHVAC OutdoorTemperature{m}%1.1f °%s{e}"
      "{s}MiElHVAC OperationTime{m}%i{e}"
      "{s}MiElHVAC TimerMode{m}%s{e}"
      "{s}MiElHVAC TimerOn{m}%i{e}"
      "{s}MiElHVAC TimerOnRemaining{m}%i{e}"
      "{s}MiElHVAC TimerOff{m}%i{e}"
      "{s}MiElHVAC TimerOffRemaining{m}%i{e}"
      "{s}MiElHVAC Compressor{m}%s{e}"
      "{s}MiElHVAC CompressorFrequency{m}%i{e}"
      "{s}MiElHVAC OperationPower{m}%i{e}"
      "{s}MiElHVAC OperationEnergy{m}%1.1f{e}"
      "{s}MiElHVAC OperationStage{m}%s{e}"
      "{s}MiElHVAC FanStage{m}%i{e}"
      "{s}MiElHVAC ModeStage{m}%s{e}",
      sensors['MiElHVAC']['Power'],
      sensors['MiElHVAC']['Mode'],
      sensors['MiElHVAC']['SetTemperature'], sensors['TempUnit'],
      sensors['MiElHVAC']['FanSpeed'],
      sensors['MiElHVAC']['SwingV'],
      sensors['MiElHVAC']['SwingH'],
      sensors['MiElHVAC']['AirDirection'],
      sensors['MiElHVAC']['Prohibit'],
      sensors['MiElHVAC']['Temperature'], sensors['TempUnit'],
      sensors['MiElHVAC']['RemoteTemperatureSensorState'],
      sensors['MiElHVAC']['RemoteTemperatureSensorAutoClearTime'],
      sensors['MiElHVAC']['OutdoorTemperature'], sensors['TempUnit'],
      sensors['MiElHVAC']['OperationTime'],
      sensors['MiElHVAC']['TimerMode'],
      sensors['MiElHVAC']['TimerOn'],
      sensors['MiElHVAC']['TimerOnRemaining'],
      sensors['MiElHVAC']['TimerOff'],
      sensors['MiElHVAC']['TimerOffRemaining'],
      sensors['MiElHVAC']['Compressor'],
      sensors['MiElHVAC']['CompressorFrequency'],
      sensors['MiElHVAC']['OperationPower'],
      sensors['MiElHVAC']['OperationEnergy'],
      sensors['MiElHVAC']['OperationStage'],
      sensors['MiElHVAC']['FanStage'],
      sensors['MiElHVAC']['ModeStage']
    )
    tasmota.web_send_decimal(msg)
  end

end

HVAC = HVAC()
tasmota.add_driver(HVAC)

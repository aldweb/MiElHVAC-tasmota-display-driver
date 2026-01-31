# Tasmota MiElHVAC Display and Web UI Controls driver

Enhanced Berry driver for Tasmota providing interactive web UI controls for Mitsubishi Electric heat pumps.

## Overview

<img src="https://raw.githubusercontent.com/MiElHVAC-tasmota-display-driver/master/images/mitsubishi_heat_pump.png" align="left" width="200" style="margin-right: 20px; margin-bottom: 20px;">This Berry driver extends the native Tasmota MiElHVAC driver by adding a web interface for Mitsubishi Electric heat pumps. Two versions are available:

**Full Version (`hvac_with_controls.be`):**
- Interactive web controls directly in the Tasmota interface
- Temperature adjustment buttons (-1°, +½°, +1°)
- Dropdown selectors for Mode, Fan Speed, Swing Vertical, and Swing Horizontal
- Real-time display of current settings (pre-selected values in dropdowns)
- Collapsible control panel to save screen space
- Formatted operation time display (days/hours/minutes)
- Automatic temperature unit adaptation (°C or °F)

**Display-Only Version (`hvac_display_only.be`):**
- Sensor readings display only
- No interactive controls
- Lightweight and minimal memory footprint
- Ideal for monitoring or when controlling via Home Assistant/MQTT

Both versions provide a clean, responsive interface matching Tasmota's design.

## Requirements

### Hardware
- **Mitsubishi Electric Heat Pump** with CN105 connector
- **ESP32 board** (DevKit, NodeMCU-32S, etc.) - **ESP8266 is NOT compatible** as Berry scripting requires ESP32
- **JST PA 5-pin connector (2.0mm pitch)** to interface with CN105

### Software
- **Tasmota32 firmware with MiElHVAC enabled** - A pre-compiled version (Tasmota 15.2.0) is included in this repository for convenience
- Alternatively, you can compile your own custom firmware (see below)

## Hardware Setup

For complete hardware setup instructions including wiring diagrams, photos, and physical installation steps, please consult these comprehensive guides:

- **[Integration with Home Assistant via Tasmota (Archive)](https://web.archive.org/web/20240314034821/https://isaiahchia.com/2022/06/)** - Complete end-to-end guide with detailed photos and CN105 pinout
- **[Hacking A Mitsubishi Heat Pump Part 1](https://chrdavis.github.io/hacking-a-mitsubishi-heat-pump-Part-1/)** - Hardware overview and initial setup
- **[Hacking A Mitsubishi Heat Pump Part 2](https://chrdavis.github.io/hacking-a-mitsubishi-heat-pump-Part-2/)** - Software configuration and testing

**Important Notes:**
- Berry scripting is only available on ESP32, not ESP8266
- Use Tasmota32 firmware, not the standard ESP8266 version
- The CN105 connector provides serial UART communication at 5V
- Proper wiring is critical - refer to the guides above for detailed instructions

## Tasmota Firmware Compilation

### Option 1: Use Pre-compiled Firmware (Quickest)

A ready-to-use Tasmota32 firmware with MiElHVAC enabled is included in this repository:
- **Version:** Tasmota 15.2.0
- **File:** `tasmota32-miel-hvac.bin` (or similar, check repository files)
- **Note:** This is provided for convenience. Regular updates are not provided, so you may want to compile your own firmware for the latest features and security patches.

### Option 2: Compile Your Own (Recommended for Latest Version)

This driver requires a custom **Tasmota32** build (for ESP32) with the MiElHVAC component enabled.

### Recommended: Use TasmoCompiler (Easiest Method)

The easiest way to compile custom Tasmota firmware is using **[TasmoCompiler](https://github.com/benzino77/tasmocompiler)** - a web GUI for custom Tasmota compilation.

**Steps:**

1. Visit one of the available TasmoCompiler instances (see [Compiling - Tasmota](https://tasmota.github.io/docs/Compile-your-build/) for options)

2. Select your **Tasmota version** (latest stable recommended)

3. Choose **tasmota32** as the build environment

4. In **Custom parameters** (step 4), add:
   ```
   #define USE_MIEL_HVAC
   ```

5. Click **Compile** and wait for the build to complete

6. Download the compiled `.bin` file

**Note:** Manual compilation with PlatformIO is also possible if you prefer a local development environment.

### Flashing the Firmware

**Recommended: Web-based Flasher**

Use the official web-based flasher (easiest, no software installation required):
- **[https://tasmota.github.io/install/](https://tasmota.github.io/install/)**
- Connect your ESP32 via USB
- Click "Install" and follow the prompts
- Upload your custom compiled `.bin` file when prompted

### Configure Tasmota Module

After flashing:

1. Connect to the Tasmota WiFi AP and configure your network
2. Navigate to **Configuration → Configure Module**
3. Set the module type appropriately for your ESP32 board
4. Configure GPIO pins:
   - **TX GPIO** → `MiEl HVAC Tx` (commonly GPIO1 or GPIO17)
   - **RX GPIO** → `MiEl HVAC Rx` (commonly GPIO3 or GPIO16)
5. Save and reboot

**Note:** GPIO pin numbers vary by ESP32 board model. Consult your board's pinout diagram and the hardware guides above.

## Driver Installation

### Choose Your Driver Version

Two versions of the Berry driver are available in this repository:

1. **`hvac_with_controls.be`** (Recommended)
   - Full-featured version with interactive web controls
   - Includes buttons for temperature adjustment
   - Dropdown selectors for Mode, Fan Speed, and Swing positions
   - Collapsible control panel

2. **`hvac_display_only.be`** (Lightweight)
   - Display-only version showing sensor readings
   - No interactive controls
   - Smaller file size, lower memory footprint
   - Ideal if you only need monitoring or control via Home Assistant/MQTT

Choose the version that best fits your needs.

### Installation Steps

1. **Download your chosen `.be` file** from this repository

2. **Upload to Tasmota**:
   - Navigate to **Tools → Manage File system**
   - Upload the `.be` file to the root directory

3. **Enable the driver**:
   - Add to `autoexec.be` (create if it doesn't exist):
     ```berry
     load('hvac_with_controls.be')
     ```
     or
     ```berry
     load('hvac_display_only.be')
     ```

4. **Reboot** Tasmota device

5. **Verify installation**:
   - Navigate to the Tasmota main page
   - You should see sensor readings from your heat pump
   - If using `hvac_with_controls.be`, click the "HVAC Control   ▼" button to reveal interactive controls

## Usage

### Web Interface Controls

**HVAC Control Button (Collapsible)**
- Click to expand/collapse the control panel
- Shows ▼ when collapsed, ▲ when expanded

**Set Temperature**
- Three buttons for temperature adjustment: -1°, +½°, +1°
- Temperature unit automatically matches your Tasmota configuration (°C or °F)
- Range: 10-31°C (50-88°F)

**Mode**
- Heat, Cool, Dry, Fan, Auto
- Current mode is pre-selected in dropdown

**Fan Speed**
- Auto, Quiet, Speed 1-4
- Current speed is pre-selected

**Swing Vertical**
- Auto, Up, Up Middle, Center, Down Middle, Down, Swing
- Current position is pre-selected

**Swing Horizontal**
- Auto, Left, Left Middle, Center, Right, Right Middle, Split, Swing
- Current position is pre-selected

### Sensor Display

The main page displays:
- Power state (on/off)
- Current mode
- Set temperature
- Fan speed
- Swing positions
- Room temperature
- Outdoor temperature
- Operation time (formatted as "Xd Xhr Xmn")
- Compressor state
- Operation power (kW)
- Operation energy (kWh)

### Customization

You can display additional sensor parameters by editing the `web_sensor()` function in either `hvac_with_controls.be` or `hvac_display_only.be`. 

Lines starting with `#` are commented out and won't display. To enable additional sensors, simply remove the `#` at the beginning of the line. For example:

```berry
# Currently hidden:
#      "{s}MiElHVAC AirDirection{m}%s{e}"

# To display, remove the #:
      "{s}MiElHVAC AirDirection{m}%s{e}"
```

Available sensors vary by heat pump model. Uncomment the parameters supported by your specific unit. Refer to your heat pump's service manual for available features.

## Troubleshooting

### No sensor readings (empty data)
- Check GPIO pin configuration in Tasmota
- Verify physical wiring connections
- Ensure TX/RX are not swapped
- Try swapping TX/RX if still no communication
- Check that CN105 has power (measure 5V between pins 2 and 3)

### Controls not responding
- Verify the driver is loaded (check Tasmota logs)
- Ensure you're using the correct firmware with `USE_MIEL_HVAC`
- Check MQTT is configured if using Home Assistant integration
- Try manual commands via console: `HVACSetTemp 22`

### "Unsupported" error messages
- Your heat pump may not support all features
- Some older models have limited functionality
- Refer to your heat pump's service manual for supported features

### Web UI issues
- Clear browser cache
- Try a different browser
- Check Tasmota logs for Berry script errors

## Tested Hardware

Any ESP32 board should work (DevKit, NodeMCU-32S, TTGO, etc.).

Mitsubishi Electric heat pump models with CN105 connector should be compatible, but your mileage may vary depending on your specific model and available features.

## Home Assistant Integration

For Home Assistant integration via MQTT, refer to:
- [Tasmota MQTT Climate integration](https://www.home-assistant.io/integrations/climate.mqtt/)
- Sample configuration provided in the referenced guides

## Credits

- **SwiCago** - Original Mitsubishi protocol reverse engineering and Arduino library
- **Tasmota team** - Native MiElHVAC driver implementation
- **Community contributors** - Hardware guides and troubleshooting

## License

This Berry driver is provided as-is for community use. Feel free to modify and share.

## Contributing

Contributions are welcome! Please:
- Test thoroughly before submitting
- Document any hardware-specific quirks
- Follow the existing code style
- Update this README if adding features

## Disclaimer

The authors take no responsibility for any damage to equipment or injury resulting from following these instructions. Proceed at your own risk.

---

**Questions?** Open an issue on GitHub or refer to the Tasmota documentation and forums.

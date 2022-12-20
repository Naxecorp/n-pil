document.addEventListener("DOMContentLoaded", () => {
  butConnect.addEventListener("click", clickConnect);

  const notSupported = document.getElementById("notSupported");
  notSupported.classList.toggle("hidden", "serial" in navigator);
});


navigator.serial.addEventListener("disconnect", (event) => {
    // TODO: Remove |event.target| from the UI.
    // If the serial port was opened, a stream error would be observed as well.
    console.log("event disco");
    window.user.bool_connect = 'false';
    console.log(bool_connect);
 })

window.user = {
    current: '',
    last :'',
    bool_connect : 'true',
}

function getBoolConnect (){
return window.user.bool_connect;
}


/**
 * @name connect
 * Opens a Web Serial connection to a micro:bit and sets up the input and
 * output stream.
 */
async function connect() {
  // CODELAB: Add code to request & open port here.
  // CODELAB: Add code to request & open port here.
  // - Request a port and open a connection.
  port = await navigator.serial.requestPort();
  // - Wait for the port to open.
  await port.open({ baudRate: 9600 });

  // CODELAB: Add code setup the output stream here.
  const encoder = new TextEncoderStream();
  outputDone = encoder.readable.pipeTo(port.writable);
   outputStream = encoder.writable;

    textDecoder = new TextDecoderStream();
    readableStreamClosed = port.readable.pipeTo(textDecoder.writable);
    reader = textDecoder.readable.getReader();

    bool_connect = 'true';
    return "connected";
  //reader = inputStream.getReader();
  //
}

/**
 * @name readLoop
 * Reads data from the input stream and displays it on screen.
 */
async function readLoop() {
  // CODELAB: Add read loop here.
  while (true) {
    const { value, done } = await reader.read();
    if (value) {
    window.user.current  = window.user.current + value;
     //console.log(value);
     if(window.user.current.includes('\n'))
     {
     //console.log("test :" , window.user.current);
     window.user.last  = window.user.current ;
     window.user.current = "";
     return window.user.last ;
     }
    }
    if (done) {
    //console.log(user.hello);
      reader.releaseLock();
      break;
    }
  }
  return "finish appeller KUKU !! ";
}



/**
 * @name writeToStream
 * Gets a writer from the output stream and send the lines to the micro:bit.
 * @param  {...string} lines lines to send to the micro:bit
 */
function writeToStream(...lines) {
  const writer = outputStream.getWriter();
lines.forEach((line) => {
  //console.log('[SEND]', line);
  writer.write(line + '\n');
});
writer.releaseLock();
}


function FlutterPage() {
  return (
    <iframe
      style={{
        width: '100%', height: '100%',
        position: 'absolute', border: '0'
      }}
      title='flutterio'
      src={`${window.location.origin}/flutter/`}
      frameBorder='0'
    ></iframe>
  );
}

export default FlutterPage;

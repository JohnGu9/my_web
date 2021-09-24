import React from "react";
import { Button, IconButton, Ripple, Typography } from "rmwc";
import { ThemeContext } from "../common/Providers";

const flutterAssets = 'flutter/assets/assets/images'

function ReactPage() {
  return (
    <div style={{ width: '100%', height: '100%', padding: '8px 0 0' }}>
      <div style={{
        width: '100%', height: '56px', padding: '0 0 0 64px',
        display: 'flex', flexDirection: 'row', alignItems: 'center',
      }}>
        <Head />
      </div>
      <div style={{ width: '100%', height: 'calc(100% - 56px)', whiteSpace: 'nowrap', overflowX: 'auto', overflowY: 'hidden' }}>
        <Body />
      </div>
    </div>
  );
}

export default ReactPage;

function Head() {
  const theme = React.useContext(ThemeContext);

  return (
    <>
      <div style={{ width: '56px', height: '56px', position: 'relative' }}>
        <img src={`${flutterAssets}/logo.png`} style={{ height: '100%', clipPath: 'circle(50%)', position: 'absolute' }} alt='logo'></img>
        <Ripple style={{ position: 'absolute' }}>
          <div style={{ width: '100%', height: '100%', clipPath: 'circle(50%)', cursor: 'pointer' }} />
        </Ripple>
      </div>
      <div style={{ flex: '1', minWidth: 0 }} />
      <Button icon='email' label='Contact me' raised />
      <div style={{ width: '8px' }} />
      <Button label='Github' />
      <div style={{ width: '42px' }} />
      <IconButton icon='menu' label='settings' style={{ color: theme.themeData.primary }} />
    </>
  );
}

const images = [
  "undraw_Coding_re_iv62.svg",
  "undraw_lightbulb_moment_re_ulyo.svg",
  "undraw_fast_loading_re_8oi3.svg",
  "undraw_Design_notes_re_eklr.svg",
  "undraw_Modern_professional_re_3b6l.svg",
];

const texts = [
  "Build app for multi platforms. For desktop / for mobile. For Windows / for Linux. Even for embedded system. ",
  "Build app into flexible forms. Cli or GUI. Professional or accessible",
  "Build app under varied languages. C/C++, Java/Kotlin, Python, Dart and JavaScript. ",
  "Build app with rich abilities. Access network, camera or hardware driver. Take advantage of database or text form data like xml or json. ",
  "Build app more customizable. ",
];

function Body() {
  const theme = React.useContext(ThemeContext);
  return (
    <>
      <div style={{ width: '64px', height: '100%', display: 'inline-block' }} />
      <Typography use='headline2' theme='primary'
        style={{ display: 'inline-block', writingMode: 'vertical-rl', transform: 'rotate(180deg)' }}>
        Hybrid Development</Typography>
      <div style={{ width: '108px', height: '100%', display: 'inline-block' }} />
      {images.map((value, index) => {
        const isOdd = index % 2 !== 0;
        return (
          <React.Fragment key={index}>
            <div style={{ width: '250px', height: '100%', display: 'inline-block', padding: '16px 0' }}>
              <div style={{
                width: '100%', height: '100%',
                display: 'flex', flexDirection: 'column-reverse',
              }}>
                <div style={isOdd ? { height: '16px' } : { flex: '1', minHeight: 0 }} />
                <Typography use='body2' style={{ padding: '24px 0 0 0', opacity: 0.5, width: '100%', whiteSpace: 'normal' }}>{texts[index]}</Typography>
                <img src={`${flutterAssets}/${images[index]}`} alt='img' height={`${250 / 3 * 4}px`}></img>
                <Typography use='headline1'>{`0${index + 1}`}</Typography>
              </div>
            </div>
            {index === images.length - 1 ? <></> :
              <div style={{
                height: '100%', display: 'inline-block', padding: '28px'
              }}>
                <div style={{ width: '2px', height: '100%', backgroundColor: theme.themeData.textHintOnBackground, }} />
              </div>
            }
          </React.Fragment>
        );
      })}
      <div style={{ width: '108px', height: '100%', display: 'inline-block' }} />
    </>
  );
}

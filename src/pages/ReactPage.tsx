import React from "react";
import { Button, IconButton, Ripple, Typography } from "rmwc";
import { ThemeContext } from "../common/Providers";

const flutterAssets = 'flutter/assets/assets/images'

function ReactPage() {
  return (
    <div style={{ width: '100%', height: '100%', padding: '8px 0 32px' }}>
      <div style={{
        width: '100%', height: '56px', padding: '0 0 0 64px',
        display: 'flex', flexDirection: 'row', alignItems: 'center',
      }}>
        <Head />
      </div>
      <div style={{ width: '100%', height: 'calc(100% - 56px)', whiteSpace: 'nowrap', overflowX: 'auto', overflowY: 'hidden' }}>
        <Content />
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

function Content() {
  return (
    <>
      <div style={{ width: '64px', height: '100%', display: 'inline-block' }} />
      <Typography use='headline2' theme='primary'
        style={{ display: 'inline-block', writingMode: 'vertical-rl', transform: 'rotate(180deg)' }}>
        Hybrid Development</Typography>
    </>
  );
}
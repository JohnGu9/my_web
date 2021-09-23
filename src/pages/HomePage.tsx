import React, { MouseEventHandler } from 'react';
import { Elevation, Ripple, Typography } from 'rmwc';
import { HistoryContext, HistoryContextType } from '../common/Providers';
import FlutterPage from './FlutterPage';

import flutter from '../assets/flutterio-icon.svg';
import react from '../assets/reactjs-icon.svg';
import { SharedAxisTransition } from '../components/Transitions';
import ReactPage from './ReactPage';

function HomePage() {
  const history = React.useContext(HistoryContext);
  return (<Content history={history} />);
}

export default HomePage;

class Content extends React.Component<Content.Props, Content.State> {
  static pageMap(route: Content.Route) {
    switch (route) {
      case Content.Route.flutterio:
        return <FlutterPage />;
      case Content.Route.reactjs:
        return <ReactPage />;
      default:
        return undefined;
    }
  }

  constructor(props: Content.Props) {
    super(props);
    const route = props.history.location.pathname as Content.Route;
    if (Object.values(Content.Route).includes(route)) {
      this.state = { children: Content.pageMap(route) }
    } else {
      props.history.replace('/');
      this.state = {}
    }
  }

  _unregisterCallback!: () => void;

  componentDidMount() {
    this._unregisterCallback = this.props.history.listen((location) => {
      const route = location.pathname as Content.Route;
      this.setState({ children: Content.pageMap(route) });
    });
  }

  componentWillUnmount() {
    this._unregisterCallback();
  }

  render() {
    return (
      <SharedAxisTransition
        type={SharedAxisTransition.Type.fromRightToLeft}
        id={this.props.history.location.pathname}
        style={{ width: '100%', height: '100%' }}>
        {this.state.children || <DefaultPage />}
      </SharedAxisTransition>
    );
  }
}

namespace Content {
  export type Props = {
    history: HistoryContextType,
  }
  export type State = {
    children?: React.ReactNode
  }

  export enum Route {
    flutterio = '/flutterio',
    reactjs = '/reactjs',
  }

}

function DefaultPage() {
  return (
    <div style={{
      height: '100%', width: '100%',
      display: 'flex', flexDirection: 'row', justifyContent: 'center', alignItems: 'center'
    }}>
      <FlutterIO />
      <ReactJS />
    </div>
  );
}

function FlutterIO() {
  const history = React.useContext(HistoryContext);
  return (
    <Card onClick={() => { history.push('/flutterio') }}>
      <img src={flutter} alt='flutterio-icon' />
      <Typography use='headline6' style={{ padding: '32px 0 0' }}>Flutter</Typography>
    </Card>
  );
}

function ReactJS() {
  const history = React.useContext(HistoryContext);
  return (
    <Card onClick={() => { history.push('/reactjs') }}>
      <img src={react} alt='reactjs-icon' />
      <Typography use='headline6' style={{ padding: '32px 0 0' }}>React</Typography>
    </Card>
  );
}

function Card(props: {
  children: React.ReactNode,
  style?: React.CSSProperties,
  onClick?: MouseEventHandler<HTMLElement>,
}) {
  const [elevation, setElevation] = React.useState(0);
  return (
    <Ripple style={props.style} onClick={props.onClick}>
      <Elevation
        z={elevation}
        transition
        onMouseOver={() => setElevation(16)}
        onMouseOut={() => setElevation(0)}
        style={{
          margin: '16px', padding: '64px', borderRadius: '4px', cursor: 'pointer',
          display: 'flex', flexDirection: 'column', alignItems: 'center',
        }}>
        {props.children}
      </Elevation>
    </Ripple>
  );
}


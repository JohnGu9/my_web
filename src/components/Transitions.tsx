import React from "react";
import delay from "../common/Delay";
import './Transitions.css';

export function SharedAxisTransition(props: SharedAxisTransition.Props) {
  return (
    <SwitchTransition id={props.id} style={props.style}
      getAnimations={() => (SharedAxisTransition.getAnimations(props.type))}>
      {props.children}
    </SwitchTransition>
  );
}

export namespace SharedAxisTransition {
  export enum Type {
    fromTopToBottom,
    fromBottomToTop,
    fromLeftToRight,
    fromRightToLeft,
    fromUpToDown,
    fromDownToUp,
  }
  export type Props = {
    children: React.ReactNode,
    type: Type,
    id: any,
    style?: React.CSSProperties,
  }

  export function getAxisXAnimations(type: SharedAxisTransition.Type.fromLeftToRight | SharedAxisTransition.Type.fromRightToLeft): {
    outAnimation: SwitchTransition.TransitionState,
    inAnimation: SwitchTransition.TransitionState,
  } {
    switch (type) {
      case SharedAxisTransition.Type.fromLeftToRight:
        return {
          outAnimation: {
            duration: 90, style: {
              opacity: 0,
              transform: 'translate(30px, 0)',
              transition: 'opacity 90ms ease-out, transform 300ms ease'
            }
          },
          inAnimation: {
            duration: 210, style: {
              animation: 'fade-in-transition 210ms ease-in, shared-axis-transition-left-to-center 300ms -90ms'
            }
          },
        };
      case SharedAxisTransition.Type.fromRightToLeft:
        return {
          outAnimation: {
            duration: 90, style: {
              opacity: 0,
              transform: 'translate(-30px, 0)',
              transition: 'opacity 90ms ease-out, transform 300ms ease'
            }
          },
          inAnimation: {
            duration: 210, style: {
              animation: 'fade-in-transition 210ms ease-in, shared-axis-transition-right-to-center 300ms -90ms'
            }
          },
        };
    }
  }

  export function getAxisYAnimations(type: SharedAxisTransition.Type.fromTopToBottom | SharedAxisTransition.Type.fromBottomToTop): {
    outAnimation: SwitchTransition.TransitionState,
    inAnimation: SwitchTransition.TransitionState,
  } {
    switch (type) {
      case SharedAxisTransition.Type.fromTopToBottom:
        return {
          outAnimation: {
            duration: 90, style: {
              opacity: 0,
              transform: 'translate(0, 30px)',
              transition: 'opacity 90ms ease-out, transform 300ms ease'
            }
          },
          inAnimation: {
            duration: 210, style: {
              animation: 'fade-in-transition 210ms ease-in, shared-axis-transition-top-to-center 300ms -90ms'
            }
          },
        };
      case SharedAxisTransition.Type.fromBottomToTop:
        return {
          outAnimation: {
            duration: 90, style: {
              opacity: 0,
              transform: 'translate(0, -30px)',
              transition: 'opacity 90ms ease-out, transform 300ms ease'
            }
          },
          inAnimation: {
            duration: 210, style: {
              animation: 'fade-in-transition 210ms ease-in, shared-axis-transition-bottom-to-center 300ms -90ms'
            }
          },
        };
    }
  }

  export function getAxisZAnimations(type: SharedAxisTransition.Type.fromUpToDown | SharedAxisTransition.Type.fromDownToUp): {
    outAnimation: SwitchTransition.TransitionState,
    inAnimation: SwitchTransition.TransitionState,
  } {
    switch (type) {
      case SharedAxisTransition.Type.fromUpToDown:
        return {
          outAnimation: {
            duration: 90, style: {
              opacity: 0,
              transform: 'scale(80%)',
              transition: 'opacity 90ms ease-out, transform 300ms ease'
            }
          },
          inAnimation: {
            duration: 210, style: {
              animation: 'fade-in-transition 210ms ease-in, shared-axis-transition-up-to-center 300ms -90ms'
            }
          },
        };
      case SharedAxisTransition.Type.fromDownToUp:
        return {
          outAnimation: {
            duration: 90, style: {
              opacity: 0,
              transform: 'scale(110%)',
              transition: 'opacity 90ms ease-out, transform 300ms ease'
            }
          },
          inAnimation: {
            duration: 210, style: {
              animation: 'fade-in-transition 210ms ease-in, shared-axis-transition-down-to-center 300ms -90ms'
            }
          },
        };
    }
  }

  export function getAnimations(type: SharedAxisTransition.Type): {
    outAnimation: SwitchTransition.TransitionState,
    inAnimation: SwitchTransition.TransitionState,
  } {
    switch (type) {
      case SharedAxisTransition.Type.fromLeftToRight:
      case SharedAxisTransition.Type.fromRightToLeft:
        return getAxisXAnimations(type);
      case SharedAxisTransition.Type.fromTopToBottom:
      case SharedAxisTransition.Type.fromBottomToTop:
        return getAxisYAnimations(type);
      case SharedAxisTransition.Type.fromUpToDown:
      case SharedAxisTransition.Type.fromDownToUp:
        return getAxisZAnimations(type);
    }
  }
}

export function FadeThroughTransition(props: {
  children: React.ReactNode,
  id: any,
  style?: React.CSSProperties,
}) {
  return (
    <SwitchTransition id={props.id} style={props.style}
      getAnimations={() => ({
        outAnimation: { duration: 90, style: { opacity: 0, transition: 'opacity 90ms ease-out' } },
        inAnimation: { duration: 210, style: { animation: 'fade-in-transition 210ms ease-in, fade-through-transition 300ms -90ms ease' } }
      })}>
      {props.children}
    </SwitchTransition>
  );
}

class SwitchTransition extends React.Component<SwitchTransition.Props, SwitchTransition.State> {
  static getDerivedStateFromProps(props: SwitchTransition.Props, state: SwitchTransition.State)
    : SwitchTransition.State | null {
    const last = state.childrenPipeLine[state.childrenPipeLine.length - 1]
    if (props.id !== last.id) {
      state.childrenPipeLine.push({ id: props.id, children: props.children });
    } else {
      last.children = props.children;
    }
    return null
  }

  constructor(props: SwitchTransition.Props) {
    super(props);
    this.state = {
      style: {},
      childrenPipeLine: [{ id: props.id, children: props.children }]
    }
  }

  _mounted: boolean = true;
  _pipeLine: SwitchTransition.PipeLine = new SwitchTransition.PipeLine();

  componentDidUpdate(oldProps: SwitchTransition.Props) {
    if (oldProps.id !== this.props.id) {
      const { outAnimation, inAnimation } = this.props.getAnimations();
      this._pipeLine.post(async () => {
        if (!this._mounted) return;
        this.setState({ style: outAnimation.style });
        await delay(outAnimation.duration);
        if (!this._mounted) return;
        this.state.childrenPipeLine.shift();// pop children
        this.setState({ style: inAnimation.style });
        await delay(inAnimation.duration);
      });
    }
  }

  componentWillUnmount() {
    this._mounted = false;
  }

  render() {
    return (
      <div style={{
        ...this.props.style,
        ...this.state.style,
      }}>
        {this.state.childrenPipeLine[0].children}
      </div>
    );
  }
}

namespace SwitchTransition {
  export type Props = {
    style?: React.CSSProperties,
    children: React.ReactNode,
    id: any,
    getAnimations: () => { outAnimation: TransitionState, inAnimation: TransitionState },
  }
  export type State = {
    style: React.CSSProperties,
    childrenPipeLine: Array<{ id: any, children: React.ReactNode }>
  }

  export type TransitionState = {
    style: React.CSSProperties,
    duration: number,
  }

  export class PipeLine {
    _running: boolean = false;
    _queue: Array<() => Promise<any>> = [];

    public post(fn: () => Promise<any>, onPause?: () => void): void {
      this._queue.push(fn);
      if (this._running === true) return;
      // start event loop
      this._running = true;
      const run = async () => {
        while (true) {
          const fn = this._queue.shift();
          if (fn) await fn();
          else break;
        };
        if (onPause) onPause();
        this._running = false;
      };
      run();
    }
  };
}

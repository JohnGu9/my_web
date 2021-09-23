import React from "react";
import delay from "../common/Delay";

export class Navigator extends React.Component<Navigator.Props, Navigator.State> {
  constructor(props: Navigator.Props) {
    super(props);
    this._children = [new Navigator.Route({ component: props.children, opaque: true, duration: 300 })];
    this.state = { children: this._children };
  }
  _children: Array<Navigator.Route>;

  async push(route: Navigator.Route) {
    route.animating = true;
    this._children.push(route);
    this.setState({ children: this._children });

    await delay(route.duration);
    route.animating = false;
    this.setState({ children: this._children });
  }

  async pop() {
    let index: number | null = null;
    for (let i = this._children.length - 1; i > 0; i++) {
      const route = this._children[i];
      if (route.state === 'push') { index = i; break; }
    }
    if (index === null) return;

    const route = this._children[index];
    route.state = 'pop';
    route.animating = true;
    route.resolvePop();
    await route.onPop; // add a bit delay for more smooth animation
    this.setState({ children: this._children });

    await delay(route.duration);
    this._children.splice(this._children.indexOf(route), 1);
    route.animating = false;
    this.setState({ children: this._children });
    route.resolvePopped();
  }

  render() {
    const defaultStyle: React.CSSProperties = {
      position: 'absolute',
      height: '100%',
      width: '100%',
    };
    return (
      <Navigator.Context.Provider value={{
        push: this.push.bind(this),
        pop: this.pop.bind(this)
      }}>
        {this.state.children.map(
          (value, index) => {
            const nextRoute = index !== (this.state.children.length - 1) ? this.state.children[index + 1] : null;
            if (nextRoute)
              if (!nextRoute.animating && nextRoute.opaque)
                return (<div key={index} />);
              else
                return (
                  <Navigator.Route.Context.Provider key={index} value={{
                    primaryState: {
                      state: value.state,
                      duration: value.duration,
                      animating: value.animating,
                    },
                    secondaryState: {
                      state: nextRoute.state,
                      duration: nextRoute.duration,
                      animating: nextRoute.animating
                    },
                  }}><div style={defaultStyle}>{value.component}</div>
                  </Navigator.Route.Context.Provider>
                );

            else
              return (
                <Navigator.Route.Context.Provider key={index} value={{
                  primaryState: {
                    state: value.state,
                    duration: value.duration,
                    animating: value.animating,
                  },
                }}><div style={defaultStyle}>{value.component}</div>
                </Navigator.Route.Context.Provider>
              );
          }
        )}
      </Navigator.Context.Provider>
    );
  }
}

export namespace Navigator {
  export type Props = { children: React.ReactNode }
  export type State = { children: Array<Route> }
  export type ContextType = {
    push: (route: Route) => Promise<void>,
    pop: () => Promise<void>
  }
  export const Context = React.createContext<ContextType>({
    push: async () => { },
    pop: async () => { }
  });
  // !cause compile error, use [ContextType]
  // export namespace Context {
  //   export type Type = {
  //     push: (route: Route) => Promise<void>,
  //     pop: () => Promise<void>
  //   }
  // }


  export class Route {
    constructor(props: {
      component: React.ReactNode,
      opaque: boolean,
      duration: number,
    }) {
      this.component = props.component;
      this.opaque = props.opaque;
      this.duration = props.duration;

      this.onPop = new Promise(resolve => this._resolvePop = resolve);
      this.onPopped = new Promise(resolve => this._resolvePopped = resolve);
    }
    readonly component: React.ReactNode;
    readonly opaque: boolean;
    readonly duration: number;

    /**
     * before pop animation
     */
    readonly onPop: Promise<void>;
    private _resolvePop!: (value: void | PromiseLike<void>) => void;
    get resolvePop() { return this._resolvePop }

    /**
     * after pop animation
     */
    readonly onPopped: Promise<void>;
    private _resolvePopped!: (value: void | PromiseLike<void>) => void;
    get resolvePopped() { return this._resolvePopped }

    state: 'push' | 'pop' = 'push';
    animating: boolean = false;
  }

  export namespace Route {
    export type RouteState = {
      state: 'push' | 'pop',
      duration: number,
      animating: boolean,
    }
    export type ContextType = {
      primaryState: RouteState,
      secondaryState?: RouteState,
    }
    export const Context = React.createContext<ContextType>({
      primaryState: {
        state: 'push',
        duration: 0,
        animating: false,
      }
    });
  }
}
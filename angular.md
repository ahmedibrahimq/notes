# Angular <!-- omit in toc -->

- [CLI](#cli)
- [Decorators](#decorators)
  - [@component](#component)
  - [@NgModule](#ngmodule)
  - [@Injectable()](#injectable)
- [Components](#components)
  - [Oninit](#oninit)
- [Modules](#modules)
  - [Angular modules](#angular-modules)
- [Directives](#directives)
- [Data Binding](#data-binding)
  - [Input property](#input-property)
  - [output property](#output-property)
- [Pipes](#pipes)
  - [built-in pipes](#built-in-pipes)
  - [Build a custom pipes](#build-a-custom-pipes)
- [Services](#services)
  - [Dependency Injection](#dependency-injection)
- [HTTP](#http)
  - [HTTPClient](#httpclient)
  - [Observables](#observables)
    - [Pipe and operators](#pipe-and-operators)
- [Routing](#routing)
  - [`Routes` Interface](#routes-interface)
  - [`RouterModule`](#routermodule)
  - [`ActivatedRoute`](#activatedroute)
  - [`RouterLink`](#routerlink)
- [Deep Dive](#deep-dive)

## CLI
- `ng serve --port <port no> --host <host name>`
- `ng g c mymodule/<component name> -m <module name>`
- `ng g m <module name> --routing`
- `-d` reports actions without writing results.
- `-it` inline template
- `-is` inline css
- `--style=` css|scss|sass|less|styl
- `-S` do not create spec files
- `--flat=true` do not create a folder
- `-c OnPush` change detection strategy 
- `ng add`
  - adds npm package to your workspace
  - and configures the project to use that library
  - as specified by the library's schematic.


## Decorators
Metadata about the actual code

### @component
https://angular.io/api/core/Component

### @NgModule
- `imports`
  - to import another modules to use.
- `declarations`
  - Declares what is inside this module (Components, Pipes)
- `bootsrap`
  - Which componet is the first one that should displayed in the UI. I.e., **the startup component**
- `exports`
  - Make sure anyone else imports this module, gets access to these exported components.
- `providers` 
  - providing services (*like exporting components*)
  - any modules that load under the root module, will have access to the providers  (publicaly availabel)

### @Injectable()
dependency injection in angular. https://angular.io/api/core/Injectable

## Components
### Oninit
- `ngOnInit` The place where we initialize the component with data

## Modules
Group of related components.  
Any components need to be declared in a module.  
The **root** module **needs to know** about **child modules**.  
Make a shared module if you have shared features e.g., components, pipes, directives, that you may reuse throughout the app.  


### Angular modules
- `BrowserModule`
  - The place where **directives** live.
  - **imported** in the **root module**.
  - 
- `CommonModule`
  - Imported into **child modules**, instead of `BrowserModule`
- `FormsModule`
  - https://angular.io/api/forms/FormsModule
 
## Directives
- ngFor
  - `<div *ngFor="let one of many"> {{ one.name }}</div>`
- ngIf
  - a way to add or remove an element form the DOM 
  - `<div *ngIf="data">{{ data.title }}</div>`
  - `else` https://angular.io/api/common/NgIf#showing-an-alternative-template-using-else
- ngClass
  - add or remove multiple css classes
  - `<div [ngClass]="{active: isActive, empty:isEmpty}"></div>`
- ngStyle
  - https://angular.io/api/common/NgStyle
- ngModel
  - Use with elements that accept the user input
  - `<input type="text" [(ngModel)]="data.title" />`

## Data Binding
Get data moved from code into tamplate and also handle events. 
- interpolation *to write a value*
  - {{ x.name }}
- property binding
  - binding to a DOM property
  - `[hidden]="!isVisible"`
  - `[disabled]="!isEnabled"`
  - `[class.active]="isActive"`
  - `[style.color]="textColor"`
  - `[innerHtml]="details"`
    - the same as {{ details }}
- event binding
  - `(click)="toggleVisible()"`
    - or `on-click="toggleVisible()"`
- Two-way binding
  - `[(ngModel)]="post.title"`
    - it will also handle input event and update `post.title`
### Input property
a way to pass a property value into a child component. make the child accepts input form the parent. get data from a parent down into a child
- Use **ngOnChanges**  if we have **a lot of properties** we want to monitor when that data changes for these props,
  ```javascript
  @Input() data: Any[];
  ngOnChanges(changes: SimpleChanges) {/* check for changes*/}
  // https://angular.io/api/core/OnChanges
  ```
- **getters and setters** another technique that can be used if we **only** have **one property to check**
  ```typescript
  // child.component.ts

  private _posts: Post[] = [];
  // only put the @Input() decorator on one of (get or set)
  @input() get posts(): Post[] { return this._posts; }

  // a way to capture when it is being set to value
  set posts(value: Post[]) { 
    if(value) {
      _posts = value;
       /* do something */
    }
  }
  ```
  ```html
  <!-- parent.component.html -->

  <app-posts [posts]="blogPosts"></app-posts>
  ```

### output property
emit data from a child back up to a parent.
- `EventEmitter<T>` a way for a child to send data to a parent 
```typescript
// child.component.ts

@Component({
  selector:'app-search',
  template:`
    // <input type="text" [value]="search" (input)="$event.target.value />
    <input type="text" [(ngModel)]="search" /> <!-- Easier way. from FormsModule --> 
  `
})

private _search: string;

get search() { return this._search }

set search(value: string) {
  this.value = value;
  this.changed.emit(this.search); // emit search value up to the parent
}

@output changed = new EventEmitter<string>();
``` 

```html
<!-- parent.component.html  -->

<!-- angular automatically extract the data from $event and pass it to the function -->
<app-search (changed)="myFun($event)"></app-search>
```


## Pipes
Format the data as we bind it out to the UI.  
### built-in pipes
https://angular.io/api?type=pipe  
- `price | currency:'USD':<'symbol', 'code'>`
  - if currency code is not passed, the browser default will be used

### Build a custom pipes
we need 
- `@Pipe({ name: echo})` decorator
  - `name` which you use in the view
- implement `PipeTransform` interface
  - implement `transform(value: any){ return value; }` function
- register it in a module
  - `declarations: [echoPipe], exports: [echoPipe]`
```javascript
// Capitalize the first character in a string

```
## Services
A singleton. [Introduction to services and dependency injection](https://angular.io/guide/architecture-services)

### Dependency Injection
Inject services into components. https://angular.io/guide/dependency-injection  
Instruct Angular to inject the dependencies of a component into its constructor.


## HTTP
Calling the server with HttpClient. https://angular.io/guide/http

### HTTPClient
https://angular.io/api/common/http/HttpClient  

### Observables
- https://angular.io/guide/observables-in-angular
- **Create** observable, and **subscribe** to it
- and once the data comes back from the server,  
then the subscription will end
- and we can **unsubscribe**.
  - **NOTICE** Web socets differs.  
- We can convert observables to promises.  
- [Using observables to pass values](https://angular.io/guide/observables)
- [Practical observable usage](https://angular.io/guide/practical-observable-usage)

#### Pipe and operators
- `catchError`
  - put catchError(myErrorHandler) operator inside `.pipe()` to handle errors
- `map`, `reduce`
  - We can operate, select, filter, the response data.
- `debounceTime`
- `takeUntil`
- [Common operators](https://angular.io/guide/rx-library#common-operators)

```typescript
// DataService.ts

@Injectable()
export class DataService {
  constructor(private http: HttpClient) {}

  getData(): Observable<any[]> { 
    return this.http.get<any[]>('data/')
      .pipe(
        map(data => data.rows || []),
        catchError(Observable.throw)
      );
  }
}
```

```typescript
// component.ts

data: any[];

constructor(private dataService: DataService) {}

ngOnInit() {
  this.dataService.getData()
    .subsrcibe((data: any[]) => this.data = data);
}
```

## Routing
### `Routes` Interface
[ Optinal ] helps us avoid typos as we define our routes.  
  - path
    - `path: ''` match the root of the website 
    - `path: '**'` match anything
  - pathMatch
    - `pathMatch: 'full'`  match on everything after the domain
  - redirectTo
    - `redirectTo: '/app-route'`
  - component
    - `{ path: 'products', component: ProductsComponent }`
  - pass data to the component
    - ```typescript
      //producs-routing.module.ts

      const routes: Routes = [
        { path: 'products', component: ProductsComponent, data: {...data} }
      ];
    - ```typescript
      // products.component.ts

      data$: Observable<any>;

      constructor(private route: ActivatedRoute) {}

      ngOnInit() {
        this.data$ = this.route.data;
      }
      ```

### `RouterModule`
To register routes
- `imports: [ RouterModule.forRoot(myRoutes) ]`
  - `forRoot` is **called one time** in the app.
- `imports: [ RouterModule.forChild(routes) ]` another option for children.

### `ActivatedRoute`
Use it to get URL/query parameters.
- `paramMap`
  - to subscribe to the parameters. It would notify us any time that the ParamMap changes.
  - Tip: Can be used if our components stay visible on the screen while the URL changes.
- `snapshot.paramMap`
  - If we want to grap the parameter once.

### `RouterLink`
Use with anchor tags `<a>` to link to a route.  
- `<a [routerLink]="['/orders', order.id]">{{order.title}}</a>`
  - `['/orders', order.id]` mapped to `'/orders/:id'`

## Deep Dive
- Constructor vs ngOnInit
  - https://stackoverflow.com/questions/35763730/difference-between-constructor-and-ngoninit
- [(ngModel)] vs [ngModel]
  - https://stackoverflow.com/questions/42504918/difference-between-ngmodel-and-ngmodel-for-binding-state-to-property
- What is the difference between Promises and Observables?
  - https://stackoverflow.com/questions/37364973/what-is-the-difference-between-promises-and-observables
  - [Cheat sheet](https://angular.io/guide/comparing-observables#cheat-sheet)
- Difference between [] and {{}} for binding state to property?
  - https://stackoverflow.com/questions/36862723/difference-between-and-for-binding-state-to-property
- Hooking into the component lifecycle
  - https://angular.io/guide/lifecycle-hooks
- Loading indication in Angular
  - https://dev.to/angular/loading-indication-in-angular-52b6
- Simple state management in Angular with only Services and RxJS
  - https://dev.to/avatsaev/simple-state-management-in-angular-with-only-services-and-rxjs-41p8
- BehaviorSubject vs Observable?
  - https://stackoverflow.com/questions/39494058/behaviorsubject-vs-observable
- Preventing Memory Leaks in Angular Observables with ngOnDestroy
  - https://www.twilio.com/blog/prevent-memory-leaks-angular-observable-ngondestroy
- Understanding Change Detection Strategy in Angular
  - https://www.digitalocean.com/community/tutorials/angular-change-detection-strategy
- Angular CLI: Custom webpack Config
  - https://www.digitalocean.com/community/tutorials/angular-custom-webpack-config
- Using Tailwind CSS Framework with Angular (custom webpack config in practical)
  - https://www.auroria.io/blog/using-tailwindcss-framework-with-angular
- How and when to unsubscribe in a component
  - https://stackoverflow.com/questions/38008334/angular-rxjs-when-should-i-unsubscribe-from-subscription
- RxJS: Don’t Unsubscribe
  - https://medium.com/@benlesh/rxjs-dont-unsubscribe-6753ed4fda87
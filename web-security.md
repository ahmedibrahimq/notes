# Web Security <!-- omit in toc -->
- [XSS Attack](#xss-attack)
  - [Types](#types)
    - [Stored XSS](#stored-xss)
    - [Reflected XSS](#reflected-xss)
    - [DOM Based](#dom-based)
    - [Blind XSS](#blind-xss)
  - [Places where XSS happens](#places-where-xss-happens)
  - [Prevent XSS](#prevent-xss)
    - [Do not trust raw user data.](#do-not-trust-raw-user-data)
    - [Escape/Sanitize user data before putting it into HTML](#escapesanitize-user-data-before-putting-it-into-html)
    - [Content Security Policy (CSP)](#content-security-policy-csp)
  - [Malicious Attachments](#malicious-attachments)
- [CSRF Cross-site request forgery Attack](#csrf-cross-site-request-forgery-attack)
  - [Where CSRF Happens](#where-csrf-happens)
  - [Prevent CSRF Attacks](#prevent-csrf-attacks)
    - [Use Safe Alternatives `{local,session}Storage`](#use-safe-alternatives-localsessionstorage)
    - [Create CSRF Token](#create-csrf-token)
    - [Validate the request `origin`](#validate-the-request-origin)
    - [Set your Cross-origin resource sharing (CORS) headers properly](#set-your-cross-origin-resource-sharing-cors-headers-properly)
- [Attack](#attack)
- [HTTPS Downgrading Attack](#https-downgrading-attack)
  - [How the attack happens](#how-the-attack-happens)
  - [Prevent HTTPS Downgrading](#prevent-https-downgrading)
    - [`upgrade-insecure-requests`](#upgrade-insecure-requests)
    - [`Strict-Transport-Security`](#strict-transport-security)
    - [HSTS Preload](#hsts-preload)
    - [Compromised Certificate Authority *(attack)*](#compromised-certificate-authority-attack)
    - [~~HTTP Public Key Pinning (HPKP)~~ *Deprecated*](#shttp-public-key-pinning-hpkps-deprecated)

## XSS Attack
Putting content in a place that is designed for text, 
but we can basically trick a system into treating it as a code and executing it.  

### Types
#### Stored XSS
When the attacker's scripts are **stored in the database**.

#### Reflected XSS
Temporary response from the server. **User input is reflected back**.  
e.g., `validation error: the username: hello<script>bad()</script> is invalid`

#### DOM Based
The server is not involved.  
e.g., if you have a query parameter that is being rendered without any escaping of any kind.  
`www.myapp.com/users/hello<script>bad()</script>` and `<%- req.params.user %>`.  
**Modern browsers detect and prevent this automatically for you (xss-filter)**  
when a part in the URL matches exactly a code that is being asked to execute.

#### Blind XSS
The same as Stored XSS, a sub-category.  
Attacking an app that you didn't even know it was there.  

e.g., You have a **secure app that you ship to public**,  
and a **less secure private app** that you use internally with your team.  
The attack can be happen when you **pull data** from the **public** app **into** your **private app**. 
The attacker can hit your internal app through that data.

### Places where XSS happens
Rich text written by user *WYSIWYG*  
Embedded content / Iframes.  
URLs controlled by user.  
When user input is reflected back.  
Render query parameters into DOM  
`innerHTML`, `eval()`.  

### Prevent XSS
#### Do not trust raw user data.
Do not put user data directly in
  - `<script><%- userData %></script>`
  - `<!-- <%- userData %> comment -->`.  
  - `<a <%- userDat a%> ="xyz" ></a>` Users shouldn't have control over html attributes
  - `<a id="<%- 'userData' %>" ></a>` 
  - `<<%- userData %>></<%- userData %>>` tag names
  - `<style><%- userData %></style>` *modern browsers detects this*

#### Escape/Sanitize user data before putting it into HTML
Keep user input as values not as code.
- Sanitize user input before
  - the data is **persist** / before storing it in the Database.
  - it is **rendered** onto the screen/DOM

- Some template libraries handle output encoding by default, but  
  this does not protect fully against XSS attacks. So we should additionally encode it ourselves. 

- All encoding should be done using a proven, trusted library
  - e.g. the OWASP Enterprise Security API (ESAPI):  
  https://github.com/ESAPI/owasp-esapi-js.

#### Content Security Policy (CSP)
Allows us to inform modern browsers which **sources** they should trust and what type of **resources** they should receive from these sources.

We can deliver it to the browsers via meta tags or HTTP response header.
Some new browsers are trying to lean more on CSP and less on separate headers and meta-tags.  
Older browsers have supports some of CSP headers. Legacy browsers like IE9 don't handle the newer version of CSP.

**CSP Via HTTP Response Header:**  
`Content-Security-Policy: script-src 'self' https://me.me; font-src data:; ...` 
  - If you do not specify anything for CSP, Everything will be allowed (by default)
  - You can have multiple directives that are separated by semicolon `;`
  - If we have multiple directives with the same name (redefined), only the first one is respected, the others would be disregarded 
  - A directive consists of a name and sources
    - name: The flavor of resource we're talking about.
      - `script-src`
      - `font-src`
        - `data:;`: means we allow base64 encoded URLs to be font sources. So in this case the font is expressed as base64 encoded URL
      - `child-src` where to spin up workers and frames
      - `connect-src`
        - What you are allowed to connect to, e.g., WebSocked, fetch, EventSource
        - EventSource: server-side events, a long polling connection in the background,  
          that let's the server ping a client to ask for some data.
      - `form-action` POST
      - `{img,media,object}-src` GET requests
      - `upgrade-insecure-requests` tells the browsers to rewrite all `HTTP` links to `HTTPS`
      - `default-src` general fallback (by default) for events that we have not provide a directive,
         here is the sources that you should allow for them.
    - sources: 
      - `'self'`: mean the origin that this frame is currently being served on
      - `'none'`: Never allow any source for that directive. Even if we have some of them already in the source code
      - `'unsafe-inline'`: allow inline JS and CSS
        - e.g., `onclick="handleClick()"`, or `<script></script>`
        - inline CSS would be something **we should probably get rid of**.
          - If we can forbid it entirely within our app, we can now **eliminate a possible XSS place entirely**.
      - `'unsafe-eval'`: allow `eval()`
        - it is not allowed by default
        - some template engines evaluates strings into code, *just in time*, for performance purposes, instead of sending the code that represents the UI,  
          so **we might have to switch it back on**.
      - Ways that we can **make 'unsafe-inline' a little less unsafe**.
        - **`'nonce-xxxxxxxxx...xxxxxxxxxx'`**:
          - generate a cryptographic nonce
            - generated on each payload
            - they increment in an unpredictable way, so that the attacker can't figure out what a future nonce might be.
          - `<script nonce="XXXX..."></script>`
          - and `Content-Security-Policy: script-src 'nonce-XXXX...'`
        - **`'sha256-......xxxxxx'`** 
          - Another way is to add a checksum to the content security policy.
          - `Content-Security-Policy: script-src 'sha-256-XXXX...'`
        - https://github.com/helmetjs/csp
      - 'https://me.me': domain/origin as an allowed source
        - **NOTICE `HTTPS`**, plain `HTTP` on the same domain would **not be allowed**.
        - an origin contains protocol, host, port
  - https://github.com/helmetjs/csp for adding CSP to an express app  
    helmetjs deals with adding headers to requests.

### Malicious Attachments
Attackers can embed harmful code into what appears a non-executable documents. e.g.,  
- There's a lot of dynamic behaviors that can be added to **PDFs**
- or to **images**. There is a non visible portion of images. like geo-tags, camera type, shutter speed,... .

**Prevent Malicious Attachments**  
- Be restrictive on file upload types. Do not allow users to upload arbitrary things.
- **Do not trust** file **extensions** or **mime** types.
- For images, just **compress images**.
  - This will drop all data that does not have anything to do with pixels shown on the screen.
- Do not oblige users to ask their web browsers to run dynamic **code in PDF**.

## CSRF Cross-site request forgery Attack
We are vulnerable if our server use cookies, sent along with the request, to identify the users.  

Attackers take advantage of that, by default **Cookie authentication** and **basic authentication** **credentials** (where your browser is asking for username and password)  
They are **sent along with each request** the user makes by default.

### Where CSRF Happens
**GET Requests That Mutate Data**
- `<img src="account.bank/transfer?to=attacker&amount=9" />`
- Do not allow **GET requests** that **mutate data**  

**Dom Elements That Initiate Requests**
- We're not safe even if we only allow POST and PUT requests.
- An attacker can make a hidden **`<form name="form" method="post" action="valuable.com">`**,  
  and submits it with JavaScript `document.form.submit()`, (without tricking the user into clicking a link)
- We won't be able to see what happens **(opaque request)**


### Prevent CSRF Attacks

#### Use Safe Alternatives `{local,session}Storage`
- `{local,session}Storage` are accessible only on the client side.
  - `sessionStorage`: destroyed when the user closes the browser.
- Neither of these are passed along, by default, with each request as cookies are.

#### Create CSRF Token
  - They are 
    - generated in unpredictable way with each page load.
    - verifiable: They have to meet a certain condition
    - disposable: Meaning we can only use each of them once, and does not reused again. 
  - It proves
    1. that we are authenticated
        - We get that token by logging in as a legitimate user.
    2. that the request came from an origin that is intended to make requests to the backend.
        - because it is reading from the local storage, or a meta tag.
        - attacker's opaque requests can't read those places.
  - Where to put it
    - `<meta>` tags
    - form hidden input `<input type="input">`
      - NOTE: sometimes browsers cache the old HTML, including the old CSRF token, specially when the user hits the back button.
    - Send it as `'X-CSRF-Token'` Header with the request.
      - Useful for SPA. Specially if we are not using JWT based auth.
  - https://github.com/expressjs/csurf CSRF token middleware

#### Validate the request `origin`
   - Modern browsers send the `origin` header, which cannot be altered by client-side code.
   - IE 11, in some cases, it does not send that header.
   - Whenever no `origin` header, there's almost always a `referer` header.
   - When we are behind a proxy, we can still look at the `host` and `X-Forwarded-Host` headers, to see where that originally came from.

#### Set your Cross-origin resource sharing (CORS) headers properly
- This permits browsers to allow us to send a request from one origin to another.
- **CORS Preflight Request**.
  - Modern web browsers automatically send this `OPTIONS request` to the server before initiating the actual request. To determine if the actual request is safe to send.
  - Headers
    - `Origin:` Where are you coming from
    - `Access-control-request-method:` Which **HTTP method** will be used
    - `Access-control-request-method:` Which HTTP headers the client might send with the actual request
  - This Happens within the browser's internals. This is not seen or controlled by the client app.
  - https://developer.mozilla.org/en-US/docs/Glossary/Preflight_request
  - **Preflight Response**  
    If the server allows that method, then it will respond with
      - `Access-Control-Allow-Methods`: Which methods (all) are allowed by the server
      - `Access-Control-Allow-Headers`: Which HTTP headers can bu used during the actual request
      - `Access-Control-Allow-Origin`:  Is the response can be shared with that given origin
      - `Access-Control-Max-Age`: How long these results can be cached

## Attack

## HTTPS Downgrading Attack
The attacker takes advantage of that the **initial Request is over plain HTTP**. The server should reply with a 301 redirect to HTTPS.  
But that initial request is still **vulnerable to a MITM attack**.  

### How the attack happens
Creating insecure proxy to downgrade that connection to insecure one
- Maintain an insecure session with the user, and maintain a secure session with the server  
  - **[ User ] <-`HTTP`-> [ MITM ] <-`🔒HTTPS`-> [ Server ]**  

- The attacker forges (Self-Signed) a certificate with the same server hostname  
  - The attacker takes advantage of the Server Name Indication (SNI)
  - **[ User ] <-`❌HTTPS`-> [ MITM ] <-`🔒HTTPS`-> [ Server ]**

### Prevent HTTPS Downgrading

#### `upgrade-insecure-requests`
- Start operating primarily over HTTPS. **Begin with a TLS handshake**, So MITM can't fake that.  
  Set `Content-Security-Policy: upgrade-insecure-requests` response header.  
  NOTE: This method fails against forged certificates

#### `Strict-Transport-Security`
- Defend against bad certificate
- Add `Strict-Transport-Security: max-age=63072000; includeSubDomains` response header
- Tell modern browsers that you are not permitted to make a plain HTTP connection to that domain
- NOTE: The users must get the first response from our domain, before the MITM, in order to work.

#### HSTS Preload 
- Add your domain to https://hstspreload.org/
- Preload web browsers with instructions to never talk to our domain over plain HTTP
- Now the users does not have an option to proceed to the domain using a bad certificate

#### Compromised Certificate Authority *(attack)*
When a trusted certificate authority (an entity that issues digital certificates)  
gets its **private key stolen**, and the attacker (**MITM**) issues **fraudulent certificates** using it,  
for any website, and **web browsers will trust** these certificates.

#### ~~HTTP Public Key Pinning (HPKP)~~ *Deprecated*
- Add `Public-Key-Pins: pin-sha256="XXXXXX..."; max-age=63072000; includeSubDomains; report-url="myapp.com/report-hack"` response header
- `pin-sha256` Public key fingerprint. A hash of our public key. 
- Make web browsers **only trust the certificate that matches the fingerprint**.
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Public_Key_Pinning
- https://www.eff.org/https-everywhere It will try to upgrade any requests it can.

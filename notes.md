### Adding Bulma customization ###

1. installer sass avec npm `npm install sass --save-dev`
2. avoir bulma installer dans le projet ou elm-styled-bulma
3. creer un fichier myStyle.scss soit a la racine ou dans src/
4. ajouter les commandes suivante dans package.json 
    ```
    "css-build": "sass src/styles.scss src/styles.css"
    "css-watch": "npm run css-build -- --watch" 
    ```
5. dans le fichier myStyle.scss ajouter les variable qu'on veut overwrite de bulma 
 Ex:  

 ```
 @charset "utf-8";

// Import a Google Font
@import url('https://fonts.googleapis.com/css?family=Nunito:400,700');

// Set your brand colors
$purple: #db3ba6;
$pink: #FA7C91;
$brown: #757763;
$beige-light: #ffffff;
$beige-lighter: #EFF0EB;

// Update Bulma's global variables
$family-sans-serif: "Nunito", sans-serif;
$grey-dark: $brown;
$grey-light: $beige-light;
$primary: $purple;
$link: $pink;
$widescreen-enabled: false;
$fullhd-enabled: false;

// Update some of Bulma's component variables
// $body-background-color: $beige-lighter;
$control-border-width: 2px;
$input-border-color: transparent;
$input-shadow: none;

// Import only what you need from Bulma
@import "../node_modules/bulma/bulma.sass";
 ```

6. executer la commande sass pour convertir en css
7. importer le fichier css dans index.js  `import "../src/styles.css"`
8. Enlever l'importation de la stylesheet de elm-bulma-styled CDN dans Main.
elm

Rouler la commande npm run css-watch pour avoir la convertion en continue ! 

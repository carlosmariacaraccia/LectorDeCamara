# Lector de camara

### Example project that loads a file from an iPhone's share extension, and reads with OCR the stored codes.


### After loading the file you can scan this codes

<div class="row">
  <div class="column">
    <p align=center>
      <img src="https://github.com/mostaza1975/LectorDeCamara/blob/master/LectorDeCamara/GitHubReadmeFiles/Image1.png?raw=true" width=180 />
      <img src="https://github.com/mostaza1975/LectorDeCamara/blob/master/LectorDeCamara/GitHubReadmeFiles/Image2.png?raw=true" width=180 />
      <img src="https://github.com/mostaza1975/LectorDeCamara/blob/master/LectorDeCamara/GitHubReadmeFiles/Image3.png?raw=true" width=180 />
      <img src="https://github.com/mostaza1975/LectorDeCamara/blob/master/LectorDeCamara/GitHubReadmeFiles/Image4.png?raw=true" width=180 />
      <img src="https://github.com/mostaza1975/LectorDeCamara/blob/master/LectorDeCamara/GitHubReadmeFiles/Image5.png?raw=true" width=180 />
    </p>
  </div>
</div>

### You need to load the file in the iPhone

To load this file you'll need to send it to the files folder o simply by mail.
Select the share menu and select the app Lector de camara to open the file.

[salida_de_depostada](https://github.com/mostaza1975/LectorDeCamara/blob/master/LectorDeCamara/GitHubReadmeFiles/salida_de_depostada.TXT)

### Working with the app
The ide of the app is to add product boxes to a pallet. To achieve this you'll need to store the products in the database, luckily you already did that by when you loaded the file in the database. After youll need to create a new pallet and add the boxes to the pallet by scanning the product codes.

1. Open the app.
2. Tap on the plus sign on the top right corner (leading for devs)
3. Add a date, a number and a maxmimun number of boxes.
4. Tap save. You'll be allowed to save only if the pallet number you've just typed is not already in the database (core data for devs).
5. You're on the main screen again, now tap on the newly created pallet cell and you'll go to the next view.
6. You should be seeing a view with you Pallet id on the top.
7. Tap OCR (on the top right corner) and scan some codes on the screen.
8. Tap the cancel buttom and you'll be able to see all the boxes you have added to your pallet.
9. On the main screen you should see a resumee of the pallet, with the total number of boxes added and their weight.


If you have any questions, mail to carloscaraccia@gmail.com



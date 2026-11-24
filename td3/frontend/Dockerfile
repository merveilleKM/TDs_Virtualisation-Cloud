FROM nginx:latest
LABEL author=Merveille

 COPY index.html /usr/share/nginx/html/

 COPY ./CSS /usr/share/nginx/html/CSS

 EXPOSE 80
 CMD ["nginx", "-g", "daemon off;"]
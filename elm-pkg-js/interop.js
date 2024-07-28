/* elm-pkg-js
port supermario_copy_to_clipboard_to_js : String -> Cmd msg
*/

const userKey = "user";

exports.init = async function (app) {
  app.ports.toJs.subscribe(function (event) {
    console.log("fromElm", event);

    if (event.tag === undefined || event.tag === null) {
      console.error("fromElm event is missing a tag", event);
      return;
    }

    if (event.tag === "GenerateIds") {
      app.ports.toElm.send(
        JSON.stringify({ tag: "IdsGenerated", data: generateIds() })
      );
      return;
    }

    if (event.tag === "StoreUserData") {
      storeUser(event.data);
      return;
    }

    if (event.tag === "LoadUserData") {
      app.ports.toElm.send(
        JSON.stringify({ tag: "UserDataLoaded", data: getUser() })
      );
      return;
    }

    if (event.tag === "Logout") {
      localStorage.removeItem(userKey);
      document.cookie = "sid=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
      app.ports.toElm.send(JSON.stringify({ tag: "LoggedOut" }));
      location.reload();
      return;
    }

    if (event.tag === "Log") {
      console.log(event.data);
      return;
    }

    console.log(`fromElm event of tag ${event.tag} not handled`, event);
  });
};

function generateIds() {
  return {
    userId: "user_" + getId(),
    deviceId: "device_" + getId(),
    eventId: "event_" + getId(),
    listId: "list_" + getId(),
    itemId: "item_" + getId(),
  };
}

function getId() {
  return window.crypto.randomUUID();
}

function storeUser(user) {
  localStorage.setItem(userKey, JSON.stringify(user));
}

function getUser() {
  const user = localStorage.getItem(userKey);
  return user ? JSON.parse(user) : {};
}
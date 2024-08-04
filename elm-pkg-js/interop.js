/* elm-pkg-js
port supermario_copy_to_clipboard_to_js : String -> Cmd msg
*/

const userKey = "user";
const frontendSyncModelKey = "frontendSyncModel";

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

    if (event.tag === "StoreFrontendSyncModel") {
      localStorage.setItem(frontendSyncModelKey, JSON.stringify(event.data));
      return;
    }

    if (event.tag === "LoadFrontendSyncModel") {
      console.log("LoadFrontendSyncModel");
      app.ports.toElm.send(
        JSON.stringify({
          tag: "FrontendSyncModelDataLoaded",
          data: getFrontendSyncModel(),
        })
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
  if (window.crypto.randomUUID) {
    return window.crypto.randomUUID();
  }

  return createPseudoUuid();
}

function createPseudoUuid() {
  let result = "";

  for (let i = 0; i < 32; i++) {
    result += getRadomCharacter();
    if ([8, 12, 16, 20].includes(i)) {
      result += "-";
    }
  }
  return result;
}

const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
const charactersLength = characters.length;
function getRadomCharacter() {
  return characters.charAt(Math.floor(Math.random() * charactersLength));
}

function storeUser(user) {
  localStorage.setItem(userKey, JSON.stringify(user));
}

function getUser() {
  const user = localStorage.getItem(userKey);
  return user ? JSON.parse(user) : {};
}

function getFrontendSyncModel() {
  const model = localStorage.getItem(frontendSyncModelKey);
  console.log("getFrontendSyncModel", model);
  return model ? JSON.parse(model) : null;
}

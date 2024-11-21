/* elm-pkg-js
port supermario_copy_to_clipboard_to_js : String -> Cmd msg
*/

const version = "v18";
const userKey = "user";
const frontendSyncModelKey = "frontendSyncModel";
const dbName = "AppDatabase";
const dbVersion = 1;
const USER_DATA_STORE = "userData";
const FRONTEND_SYNC_MODEL_STORE = "frontendSyncModel";
const TO_JS_PORT = "toJs";
const TO_ELM_PORT = "toElm";
const SERVICE_WORKER_PATH = "/serviceWorker.js";

let globalDB;
let setupIndexedDBPromise;

async function getDb() {
  await setupIndexedDBPromise;
  return globalDB;
}

function setupIndexedDB() {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open(dbName, dbVersion);

    request.onerror = (event) => {
      console.error("IndexedDB error:", event.target.error);
      reject(event.target.error);
    };

    request.onsuccess = (event) => {
      globalDB = event.target.result;
      resolve();
    };

    request.onupgradeneeded = (event) => {
      globalDB = event.target.result;
      globalDB.createObjectStore("userData", { keyPath: "key" });
      globalDB.createObjectStore("frontendSyncModel", { keyPath: "key" });
    };
  });
}

exports.init = async function (app) {
  setupIndexedDBPromise = setupIndexedDB();
  app.ports[TO_JS_PORT].subscribe(async function (event) {
    console.log("fromElm", event);

    if (event.tag === undefined || event.tag === null) {
      console.error("fromElm event is missing a tag", event);
      return;
    }

    switch (event.tag) {
      case "GenerateIds":
        app.ports[TO_ELM_PORT].send(
          JSON.stringify({ tag: "IdsGenerated", data: generateIds() })
        );
        break;

      case "StoreUserData":
        await storeUser(event.data);
        break;

      case "LoadUserData":
        const userData = await getUser();
        console.log("getUserData", userData);
        app.ports[TO_ELM_PORT].send(
          JSON.stringify({ tag: "UserDataLoaded", data: userData })
        );

        break;

      case "LoadVersion":
        app.ports[TO_ELM_PORT].send(
          JSON.stringify({ tag: "VersionLoaded", data: version })
        );
        break;

      case "StoreFrontendSyncModel":
        await storeFrontendSyncModel(event.data);
        break;

      case "LoadFrontendSyncModel":
        console.log("LoadFrontendSyncModel");
        const frontendSyncModel = await getFrontendSyncModel();
        app.ports[TO_ELM_PORT].send(
          JSON.stringify({
            tag: "FrontendSyncModelDataLoaded",
            data: frontendSyncModel,
          })
        );

        break;

      case "Logout":
        await clearData();
        document.cookie =
          "sid=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
        app.ports[TO_ELM_PORT].send(JSON.stringify({ tag: "LoggedOut" }));
        location.reload();

        break;

      case "Log":
        console.log(event.data);
        break;

      case "CopyToClipboard":
        try {
          await navigator.clipboard.writeText(event.data);
        } catch (err) {
          console.error("Failed to copy text: ", err);
        }
        break;

      default:
        console.log(`fromElm event of tag ${event.tag} not handled`, event);
    }
  });
  setupServiceworker();
  await setupIndexedDBPromise;
};

function setupServiceworker() {
  if ("serviceWorker" in navigator) {
    window.addEventListener("load", function () {
      navigator.serviceWorker
        .register(SERVICE_WORKER_PATH)
        .then((res) => {
          console.log("service worker registered");
          res.addEventListener("message", (event) => {
            console.log("service worker message", event);
            if (event.data && event.data.version) {
              localStorage.setItem("version", event.data.version);
              app.ports[TO_ELM_PORT].send(
                JSON.stringify({
                  tag: "VersionLoaded",
                  data: event.data.version,
                })
              );
            }
          });
        })
        .catch((err) => console.log("service worker not registered", err));
    });
  }
}

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

async function storeUser(user) {
  const db = await getDb();
  const transaction = db.transaction([USER_DATA_STORE], "readwrite");
  const store = transaction.objectStore(USER_DATA_STORE);
  return store.put({ key: userKey, value: user });
}

async function getUser() {
  try {
    const db = await getDb();
    const transaction = db.transaction([USER_DATA_STORE], "readwrite");
    const store = transaction.objectStore(USER_DATA_STORE);
    const request = store.get(userKey);

    const result = await new Promise((resolve, reject) => {
      request.onsuccess = (event) => resolve(event.target.result);
      request.onerror = (event) => reject(event.target.error);
    });

    console.log("getUser result", result);

    if (result && result.value) {
      return result.value;
    } else {
      const localStorageUser = localStorage.getItem(userKey);
      if (localStorageUser) {
        const parsedUser = JSON.parse(localStorageUser);
        // Migrate user data from localStorage to IndexedDB
        await storeUser(parsedUser);
        console.log("User data migrated from localStorage to IndexedDB");
        return parsedUser;
      }
      return {};
    }
  } catch (error) {
    console.error("Error in getUser:", error);
    const localStorageUser = localStorage.getItem(userKey);
    return localStorageUser ? JSON.parse(localStorageUser) : {};
  }
}

async function storeFrontendSyncModel(model) {
  const db = await getDb();
  const transaction = db.transaction([FRONTEND_SYNC_MODEL_STORE], "readwrite");
  const store = transaction.objectStore(FRONTEND_SYNC_MODEL_STORE);
  return store.put({ key: frontendSyncModelKey, value: model });
}

async function getFrontendSyncModel() {
  try {
    const db = await getDb();
    const transaction = db.transaction([FRONTEND_SYNC_MODEL_STORE], "readonly");
    const store = transaction.objectStore(FRONTEND_SYNC_MODEL_STORE);
    const request = store.get(frontendSyncModelKey);

    const result = await new Promise((resolve, reject) => {
      request.onsuccess = (event) => resolve(event.target.result);
      request.onerror = (event) => reject(event.target.error);
    });

    console.log("getFrontendSyncModel result", result);

    if (result && result.value) {
      console.log("getFrontendSyncModel from IndexedDB", result);
      return result.value;
    } else {
      const localStorageModel = localStorage.getItem(frontendSyncModelKey);
      console.log("getFrontendSyncModel from localStorage", localStorageModel);
      return localStorageModel ? JSON.parse(localStorageModel) : null;
    }
  } catch (error) {
    console.error("Error in getFrontendSyncModel:", error);
    const localStorageModel = localStorage.getItem(frontendSyncModelKey);
    console.log(
      "getFrontendSyncModel from localStorage (on error)",
      localStorageModel
    );
    return localStorageModel ? JSON.parse(localStorageModel) : null;
  }
}

async function clearData() {
  const db = await getDb();
  const transaction = db.transaction(
    [USER_DATA_STORE, FRONTEND_SYNC_MODEL_STORE],
    "readwrite"
  );
  const userDataStore = transaction.objectStore(USER_DATA_STORE);
  const frontendSyncModelStore = transaction.objectStore(
    FRONTEND_SYNC_MODEL_STORE
  );

  try {
    await Promise.all([
      userDataStore.delete(userKey),
      frontendSyncModelStore.delete(frontendSyncModelKey),
    ]);

    localStorage.removeItem(userKey);
    localStorage.removeItem(frontendSyncModelKey);
  } catch (error) {
    console.error("Error clearing data:", error);
    throw error;
  }
}

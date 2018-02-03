import  {
  RECEIVE_GAMES,
  RECEIVE_ONE_GAME
} from '../actions/games';
import {
  RECEIVE_ONE_COLLECTION,
  RECEIVE_COLLECTIONS
} from '../actions/collections';
import { merge } from 'lodash';

export default (state = {}, action) => {
  let newState;
  switch(action.type) {
    case RECEIVE_ONE_GAME:
      newState = merge({}, state);

      newState[action.game.id] = action.game;

      return newState;
    case RECEIVE_GAMES:
      newState = merge({}, state, action.games);
      return newState;

    case RECEIVE_ONE_COLLECTION:
      newState = merge({}, state, action.games);
      return newState;

    case RECEIVE_COLLECTIONS:
      newState = merge({}, state, action.games);
      return newState;
      // if (action.games) {
      //   return action.games;
      // } else {
      //   return null;
      // }
    default:
      return state;
  }
};

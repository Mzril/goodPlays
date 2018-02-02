import {
  REMOVE_COLLECTION,
  RECEIVE_COLLECTIONS,
  RECEIVE_ONE_COLLECTION,
} from '../actions/collections';
import {merge} from 'lodash';

export default (state = {}, action) => {
  let newState;
  switch(action.type) {
    case RECEIVE_ONE_COLLECTION:
      newState = merge({}, state);
      newState[action.collection.id] = action.collection;
      return newState;
    case RECEIVE_COLLECTIONS:
      return merge({}, state, action.collections);
    case REMOVE_COLLECTION:
      newState = merge({}, state);
      delete newState[action.collection.id];
      return newState;
    default:
      return state;
  }

};

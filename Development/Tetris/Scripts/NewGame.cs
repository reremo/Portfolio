using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewGame : MonoBehaviour
{
    GameObject _gameObject;
    GameSystem _gameSystem;

    void Start()
    {
        _gameObject = GameObject.Find("GameSystem");
        _gameSystem = _gameObject.GetComponent<GameSystem>();
    
    }
    public void OnClick()
    {
        _gameSystem.createNewGame();
        Debug.Log("押された!"); 
    }
}

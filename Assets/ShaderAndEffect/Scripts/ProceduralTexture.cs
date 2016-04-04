using UnityEngine;
using System.Collections;

public class ProceduralTexture : MonoBehaviour {

    public int widthHeight = 512;
    public Texture2D generatedTexture;
    public Transform trans;
    private Material currentMat;
    private Vector2 centerPosition;

	// Use this for initialization
	void Start () {
	    if(!currentMat)
        {
            currentMat = trans.GetComponent<Renderer>().sharedMaterial;
            if(!currentMat)
            {
                Debug.LogWarning("Cannot find material on : " + trans.name);
            }
        }
        if(currentMat)
        {
            centerPosition = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateParabola();
            currentMat.SetTexture("_MainTex", generatedTexture);
        }
	}

    Texture2D GenerateParabola()
    {
        Texture2D proceduralTex = new Texture2D(widthHeight, widthHeight);
        Vector2 centerPixelPosition = centerPosition * widthHeight;
        for(int x = 0; x < widthHeight; x++)
        {
            for(int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x, y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPosition) / (widthHeight * 0.5f);
                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));
                Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTex.SetPixel(x, y, pixelColor);
            }
        }
        proceduralTex.Apply();
        return proceduralTex;
    }

	// Update is called once per frame
	void Update () {
	
	}
}
